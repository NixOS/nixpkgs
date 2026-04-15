{
  config,
  stdenv,
  lib,
  buildEnv,
  writeShellScriptBin,
  fetchurl,
  vscode,
  buildPackages,
  unzip,
  makeSetupHook,
  writeShellScript,
  jq,
  vscode-extension-update-script,
}:
let
  unpackVsixSetupHook = makeSetupHook {
    name = "unpack-vsix-setup-hook";
    substitutions = {
      unzip = "${buildPackages.unzip}/bin/unzip";
    };
    meta.license = lib.licenses.mit;
  } ./unpack-vsix-setup-hook.sh;

  # Path to Microsoft's vsce-sign binary bundled with the (unfree) vscode.
  # Exported below so the update script can verify signatures at update time
  # using the same verifier the build-time hook uses.
  vsceSignExe =
    if stdenv.hostPlatform.isDarwin then
      "${vscode}/Applications/${vscode.longName}.app/Contents/Resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign"
    else
      "${vscode}/lib/vscode/resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign";

  # Single source of truth for the verification logic, shared with the update
  # script (pkgs/by-name/vs/vscode-extension-update/vscode_extension_update.py).
  verifyVsixSignatureScript = writeShellScript "verify-vsix-signature" (
    builtins.readFile ./verify-vsix-signature.sh
  );

  verifyVsixSignatureSetupHook = makeSetupHook {
    name = "verify-vsix-signature-setup-hook";
    substitutions = {
      vsceSign = vsceSignExe;
      verifyScript = verifyVsixSignatureScript;
    };
  } ./verify-vsix-signature-setup-hook.sh;

  # Global default for `verifySignature`, set via nixpkgs config:
  # `vscodeExtensions.verifySignature = true` verifies every signed extension.
  globalVerifySignature = config.vscodeExtensions.verifySignature or false;
  buildVscodeExtension = lib.extendMkDerivation {
    constructDrv = stdenv.mkDerivation;
    excludeDrvArgNames = [
      "vscodeExtUniqueId"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        pname ? null, # Only optional for backward compatibility.
        # Same as "Unique Identifier" on the extension's web page.
        # For the moment, only serve as unique extension dir.
        vscodeExtPublisher,
        vscodeExtName,
        vscodeExtUniqueId,
        configurePhase ? ''
          runHook preConfigure
          runHook postConfigure
        '',
        buildPhase ? ''
          runHook preBuild
          runHook postBuild
        '',
        dontPatchELF ? true,
        dontStrip ? true,
        nativeBuildInputs ? [ ],
        passthru ? { },
        ...
      }@args:
      {
        pname = "vscode-extension-${pname}";

        passthru = {
          updateScript = vscode-extension-update-script { };
        }
        // passthru
        // {
          inherit vscodeExtPublisher vscodeExtName vscodeExtUniqueId;
        };

        inherit
          configurePhase
          buildPhase
          dontPatchELF
          dontStrip
          ;

        # Some .vsix files contain other directories (e.g., `package`) that we don't use.
        # If other directories are present but `sourceRoot` is unset, the unpacker phase fails.
        sourceRoot = args.sourceRoot or "extension";

        # This cannot be removed, it is used by some extensions.
        installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

        nativeBuildInputs = [
          unpackVsixSetupHook
        ]
        # Opt-in: verification pulls the unfree vsce-sign (from vscode) into the
        # build closure, so it is off by default to keep signed extensions free
        # and buildable on Hydra / with vscodium. Enable with `verifySignature`.
        ++ lib.optional (
          (finalAttrs.verifySignature or globalVerifySignature)
          && (finalAttrs.signatureArchive or null) != null
          && vscode.hasVsceSign
        ) verifyVsixSignatureSetupHook
        ++ nativeBuildInputs;

        # vsce-sign validates Microsoft's certificate chain via Apple's
        # Security.framework, which reads the system keychain and MDS store.
        # Grant those reads under Darwin's relaxed sandbox.
        sandboxProfile =
          lib.optionalString
            (
              (finalAttrs.verifySignature or globalVerifySignature)
              && (finalAttrs.signatureArchive or null) != null
              && stdenv.hostPlatform.isDarwin
              && vscode.hasVsceSign
            )
            ''
              (allow file-read*
                (literal "/Library/Keychains/System.keychain")
                (literal "/private/var/db/mds/system/mdsDirectory.db")
                (literal "/private/var/db/mds/system/mdsObject.db"))
            '';

        installPhase =
          args.installPhase or ''
            runHook preInstall

            mkdir -p "$out/$installPrefix"
            find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

            runHook postInstall
          '';
      };
  };

  mktplcAssetBaseUrl =
    {
      publisher,
      name,
      version,
      ...
    }:
    "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname";

  fetchVsixFromVscodeMarketplace =
    mktplcExtRef: fetchurl (import ./mktplcExtRefToFetchArgs.nix mktplcExtRef);

  # Fetch signature archive for cryptographic verification
  fetchSignatureFromVscodeMarketplace =
    mktplcExtRef:
    let
      inherit (mktplcExtRef) publisher name;
      arch = mktplcExtRef.arch or "";
      archurl = if arch == "" then "" else "?targetPlatform=${arch}";
      signatureHash = mktplcExtRef.signatureHash or "";
    in
    if signatureHash != "" then
      fetchurl {
        url = "${mktplcAssetBaseUrl mktplcExtRef}/Microsoft.VisualStudio.Services.VsixSignature${archurl}";
        name = "${publisher}-${name}.sigzip";
        hash = signatureHash;
      }
    else
      null;

  buildVscodeMarketplaceExtension = lib.extendMkDerivation {
    constructDrv = buildVscodeExtension;
    excludeDrvArgNames = [
      "mktplcRef"
      "vsix"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        name ? "",
        src ? null,
        vsix ? null,
        mktplcRef,
        ...
      }:
      assert "" == name;
      assert null == src;
      {
        inherit (mktplcRef) version;
        pname = "${mktplcRef.publisher}-${mktplcRef.name}";
        src = if (vsix != null) then vsix else fetchVsixFromVscodeMarketplace mktplcRef;
        vscodeExtPublisher = mktplcRef.publisher;
        vscodeExtName = mktplcRef.name;
        vscodeExtUniqueId = "${mktplcRef.publisher}.${mktplcRef.name}";
        signatureArchive = fetchSignatureFromVscodeMarketplace mktplcRef;
      };
  };

  mktplcRefAttrList = [
    "name"
    "publisher"
    "version"
    "sha256"
    "hash"
    "arch"
    "signatureHash"
  ];

  mktplcExtRefToExtDrv =
    ext:
    buildVscodeMarketplaceExtension (
      removeAttrs ext mktplcRefAttrList
      // {
        mktplcRef = builtins.intersectAttrs (lib.genAttrs mktplcRefAttrList (_: null)) ext;
      }
    );

  extensionFromVscodeMarketplace = mktplcExtRefToExtDrv;
  extensionsFromVscodeMarketplace =
    mktplcExtRefList: map extensionFromVscodeMarketplace mktplcExtRefList;

  vscodeWithConfiguration = import ./vscodeWithConfiguration.nix {
    inherit lib extensionsFromVscodeMarketplace writeShellScriptBin;
    vscodeDefault = vscode;
  };

  vscodeExts2nix = import ./vscodeExts2nix.nix {
    inherit lib writeShellScriptBin;
    vscodeDefault = vscode;
  };

  vscodeEnv = import ./vscodeEnv.nix {
    inherit
      lib
      buildEnv
      writeShellScriptBin
      extensionsFromVscodeMarketplace
      jq
      ;
    vscodeDefault = vscode;
  };

  toExtensionJsonEntry = ext: rec {
    identifier = {
      id = ext.vscodeExtUniqueId;
      uuid = "";
    };

    version = ext.version;

    relativeLocation = ext.vscodeExtUniqueId;

    location = {
      "$mid" = 1;
      fsPath = ext.outPath + "/share/vscode/extensions/${ext.vscodeExtUniqueId}";
      path = location.fsPath;
      scheme = "file";
    };

    metadata = {
      id = "";
      publisherId = "";
      publisherDisplayName = ext.vscodeExtPublisher;
      targetPlatform = "undefined";
      isApplicationScoped = false;
      updated = false;
      isPreReleaseVersion = false;
      installedTimestamp = 0;
      preRelease = false;
    };
  };

  toExtensionJson = extensions: builtins.toJSON (map toExtensionJsonEntry extensions);
in
{
  inherit
    vsceSignExe
    fetchVsixFromVscodeMarketplace
    buildVscodeExtension
    buildVscodeMarketplaceExtension
    extensionFromVscodeMarketplace
    extensionsFromVscodeMarketplace
    vscodeWithConfiguration
    vscodeExts2nix
    vscodeEnv
    toExtensionJsonEntry
    toExtensionJson
    ;
}
