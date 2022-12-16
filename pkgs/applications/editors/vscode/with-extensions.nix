{ lib, stdenv, runCommand, buildEnv, vscode, makeWrapper, writeText
, vscodeExtensions ? [] }:

/*
  `vscodeExtensions`
   :  A set of vscode extensions to be installed alongside the editor. Here's a an
      example:

      ~~~
      vscode-with-extensions.override {

        # When the extension is already available in the default extensions set.
        vscodeExtensions = with vscode-extensions; [
          bbenoist.nix
        ]

        # Concise version from the vscode market place when not available in the default set.
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "code-runner";
            publisher = "formulahendry";
            version = "0.6.33";
            sha256 = "166ia73vrcl5c9hm4q1a73qdn56m0jc7flfsk5p5q41na9f10lb0";
          }
        ];
      }
      ~~~

      This expression should fetch
       -  the *nix* vscode extension from whatever source defined in the
          default nixpkgs extensions set `vscodeExtensions`.

       -  the *code-runner* vscode extension from the marketplace using the
          following url:

          ~~~
          https://bbenoist.gallery.vsassets.io/_apis/public/gallery/publisher/bbenoist/extension/nix/1.0.1/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage
          ~~~

      The original `code` executable will be wrapped so that it uses the set of pre-installed / unpacked
      extensions as its `--extensions-dir`.
*/

let
  inherit (vscode) executableName longName;
  wrappedPkgVersion = lib.getVersion vscode;
  wrappedPkgName = lib.removeSuffix "-${wrappedPkgVersion}" vscode.name;

  toExtensionJsonEntry = drv: rec {
    identifier = {
      id = "${drv.vscodeExtPublisher}.${drv.vscodeExtName}";
      uuid = "";
    };

    version = drv.version;

    location = {
      "$mid" = 1;
      fsPath = drv.outPath + "/share/vscode/extensions/${drv.vscodeExtUniqueId}";
      path = location.fsPath;
      scheme = "file";
    };

    metadata = {
      id = identifier.uuid;
      publisherId = "";
      publisherDisplayName = drv.vscodeExtPublisher;
      targetPlatform = "undefined";
      isApplicationScoped = false;
      updated = false;
      isPreReleaseVersion = false;
      installedTimestamp = 0;
      preRelease = false;
    };
  };

  extensionJson = builtins.toJSON (map toExtensionJsonEntry vscodeExtensions);
  extensionJsonFile = writeText "extensions.json" extensionJson;
  extensionJsonOutput = runCommand "vscode-extensions-json" {} ''
    mkdir -p $out/share/vscode/extensions
    cp ${extensionJsonFile} $out/share/vscode/extensions/extensions.json
  '';

  combinedExtensionsDrv = buildEnv {
    name = "vscode-extensions";
    paths = vscodeExtensions ++ [ extensionJsonOutput ];
  };

  extensionsFlag = ''
    --add-flags "--extensions-dir ${combinedExtensionsDrv}/share/vscode/extensions"
  '';
in

# When no extensions are requested, we simply redirect to the original
# non-wrapped vscode executable.
runCommand "${wrappedPkgName}-with-extensions-${wrappedPkgVersion}" {
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ vscode ];
  dontPatchELF = true;
  dontStrip = true;
  meta = vscode.meta;
} (if stdenv.isDarwin then ''
  mkdir -p $out/bin/
  mkdir -p "$out/Applications/${longName}.app/Contents/MacOS"

  for path in PkgInfo Frameworks Resources _CodeSignature Info.plist; do
    ln -s "${vscode}/Applications/${longName}.app/Contents/$path" "$out/Applications/${longName}.app/Contents/"
  done

  makeWrapper "${vscode}/bin/${executableName}" "$out/bin/${executableName}" ${extensionsFlag}
  makeWrapper "${vscode}/Applications/${longName}.app/Contents/MacOS/Electron" "$out/Applications/${longName}.app/Contents/MacOS/Electron" ${extensionsFlag}
'' else ''
  mkdir -p "$out/bin"
  mkdir -p "$out/share/applications"
  mkdir -p "$out/share/pixmaps"

  ln -sT "${vscode}/share/pixmaps/code.png" "$out/share/pixmaps/code.png"
  ln -sT "${vscode}/share/applications/${executableName}.desktop" "$out/share/applications/${executableName}.desktop"
  ln -sT "${vscode}/share/applications/${executableName}-url-handler.desktop" "$out/share/applications/${executableName}-url-handler.desktop"
  makeWrapper "${vscode}/bin/${executableName}" "$out/bin/${executableName}" ${extensionsFlag}
'')
