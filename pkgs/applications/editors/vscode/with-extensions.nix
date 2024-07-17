{
  lib,
  stdenv,
  runCommand,
  buildEnv,
  vscode,
  vscode-utils,
  makeWrapper,
  writeTextFile,
  vscodeExtensions ? [ ],
}:

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

  extensionJsonFile = writeTextFile {
    name = "vscode-extensions-json";
    destination = "/share/vscode/extensions/extensions.json";
    text = vscode-utils.toExtensionJson vscodeExtensions;
  };

  combinedExtensionsDrv = buildEnv {
    name = "vscode-extensions";
    paths = vscodeExtensions ++ [ extensionJsonFile ];
  };

  extensionsFlag = ''
    --add-flags "--extensions-dir ${combinedExtensionsDrv}/share/vscode/extensions"
  '';
in

runCommand "${wrappedPkgName}-with-extensions-${wrappedPkgVersion}"
  {
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ vscode ];
    dontPatchELF = true;
    dontStrip = true;
    meta = vscode.meta;
  }
  (
    if stdenv.isDarwin then
      ''
        mkdir -p $out/bin/
        mkdir -p "$out/Applications/${longName}.app/Contents/MacOS"

        for path in PkgInfo Frameworks Resources _CodeSignature Info.plist; do
          ln -s "${vscode}/Applications/${longName}.app/Contents/$path" "$out/Applications/${longName}.app/Contents/"
        done

        makeWrapper "${vscode}/bin/${executableName}" "$out/bin/${executableName}" ${extensionsFlag}
        makeWrapper "${vscode}/Applications/${longName}.app/Contents/MacOS/Electron" "$out/Applications/${longName}.app/Contents/MacOS/Electron" ${extensionsFlag}
      ''
    else
      ''
        mkdir -p "$out/bin"
        mkdir -p "$out/share/applications"
        mkdir -p "$out/share/pixmaps"

        ln -sT "${vscode}/share/pixmaps/vs${executableName}.png" "$out/share/pixmaps/vs${executableName}.png"
        ln -sT "${vscode}/share/applications/${executableName}.desktop" "$out/share/applications/${executableName}.desktop"
        ln -sT "${vscode}/share/applications/${executableName}-url-handler.desktop" "$out/share/applications/${executableName}-url-handler.desktop"
        makeWrapper "${vscode}/bin/${executableName}" "$out/bin/${executableName}" ${extensionsFlag}
      ''
  )
