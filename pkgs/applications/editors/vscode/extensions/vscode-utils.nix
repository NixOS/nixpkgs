{ stdenv, lib, buildEnv, writeShellScriptBin, fetchurl, vscode, unzip, jq }:
let
  buildVscodeExtension = a@{
    name,
    src,
    # Same as "Unique Identifier" on the extension's web page.
    # For the moment, only serve as unique extension dir.
    vscodeExtUniqueId,
    configurePhase ? ''
      runHook preConfigure
      runHook postConfigure
    '',
    buildPhase ?''
      runHook preBuild
      runHook postBuild
    '',
    dontPatchELF ? true,
    dontStrip ? true,
    nativeBuildInputs ? [],
    ...
  }:
  stdenv.mkDerivation ((removeAttrs a [ "vscodeExtUniqueId" ]) // {

    name = "vscode-extension-${name}";

    inherit vscodeExtUniqueId;
    inherit configurePhase buildPhase dontPatchELF dontStrip;

    installPrefix = "share/vscode/extensions/${vscodeExtUniqueId}";

    nativeBuildInputs = [ unzip ] ++ nativeBuildInputs;

    installPhase = ''

      runHook preInstall

      mkdir -p "$out/$installPrefix"
      find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

      runHook postInstall
    '';

  });

  fetchVsixFromVscodeMarketplace = mktplcExtRef:
    fetchurl (import ./mktplcExtRefToFetchArgs.nix mktplcExtRef);

  buildVscodeMarketplaceExtension = a@{
    name ? "",
    src ? null,
    vsix ? null,
    mktplcRef,
    ...
  }: assert "" == name; assert null == src;
  buildVscodeExtension ((removeAttrs a [ "mktplcRef" "vsix" ]) // {
    name = "${mktplcRef.publisher}-${mktplcRef.name}-${mktplcRef.version}";
    src = if (vsix != null)
      then vsix
      else fetchVsixFromVscodeMarketplace mktplcRef;
    vscodeExtUniqueId = "${mktplcRef.publisher}.${mktplcRef.name}";
  });

  mktplcRefAttrList = [
    "name"
    "publisher"
    "version"
    "sha256"
    "arch"
  ];

  mktplcExtRefToExtDrv = ext:
    buildVscodeMarketplaceExtension (removeAttrs ext mktplcRefAttrList // {
      mktplcRef = builtins.intersectAttrs (lib.genAttrs mktplcRefAttrList (_: null)) ext;
    });

  extensionFromVscodeMarketplace = mktplcExtRefToExtDrv;
  extensionsFromVscodeMarketplace = mktplcExtRefList:
    builtins.map extensionFromVscodeMarketplace mktplcExtRefList;

  vscodeWithConfiguration = import ./vscodeWithConfiguration.nix {
   inherit lib extensionsFromVscodeMarketplace writeShellScriptBin;
   vscodeDefault = vscode;
  };


  vscodeExts2nix = import ./vscodeExts2nix.nix {
    inherit lib writeShellScriptBin;
    vscodeDefault = vscode;
  };

  vscodeEnv = import ./vscodeEnv.nix {
    inherit lib buildEnv writeShellScriptBin extensionsFromVscodeMarketplace jq;
    vscodeDefault = vscode;
  };
in
{
  inherit fetchVsixFromVscodeMarketplace buildVscodeExtension
          buildVscodeMarketplaceExtension extensionFromVscodeMarketplace
          extensionsFromVscodeMarketplace
          vscodeWithConfiguration vscodeExts2nix vscodeEnv;
}
