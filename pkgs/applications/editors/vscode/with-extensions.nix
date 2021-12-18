{ lib
, stdenvNoCC
, symlinkJoin
, vscode
, writeShellScript
, vscodeExtensions ? [ ]
, allowUserExtensions ? true
, mergerfs ? null
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

# When no extensions are requested, we simply don't build

if allowUserExtensions && vscodeExtensions == [ ] then vscode else

let
  # if vscode is itself another vscode-with-extensions we avoid to build it too
  _vscode = vscode.vscode or vscode;
  combinedExtensionsDrv = symlinkJoin {
    name = "vscode-extensions";
    paths = map
      (p: "${p}/share/vscode/extensions")
      (vscodeExtensions ++ vscode.vscodeExtensions or [ ]);
  };
  setExtDir = ''
    extensionsDir="${combinedExtensionsDrv}"
  '';
in

stdenvNoCC.mkDerivation rec {
  dontPatchELF = true;
  dontStrip = true;
  pname = "${vscode.pname}-with-extensions";

  vscode = _vscode;
  inherit (vscode)
    meta extensionHomePath executableName
    longName shortName userHomePath version;
  passthru = {
    inherit vscodeExtensions;
  };

  passAsFile = [ "buildCommand" ];
  buildCommand = ''
    mkVscWrapper()(
      o="$out/$1"
      install -Dm0777 "${writeShellScript "vsc-wrapper" (
        if allowUserExtensions then ''
          homeExt="$HOME/${extensionHomePath}"
          mkdir -p "$homeExt"
          # assume the store path is unique enough
          # that it can replace a tmpdir suffix
          extensionsDir="''${XDG_RUNTIME_DIR:-''${TEMPDIR:-/tmp}}/codeExts${combinedExtensionsDrv}"
          # avoid remounting after closing and reopening vscode
          if ! (mount | grep "$extensionsDir" > /dev/null)
          then
            mkdir -p $extensionsDir
            ${mergerfs}/bin/mergerfs \
              -o use_ino,cache.files=partial,dropcacheonclose=true,category.create=mfs \
              "${combinedExtensionsDrv}=RO:$homeExt=RW" "$extensionsDir" || \
              ${setExtDir}
          fi
      '' else setExtDir)}" "$o"
      echo exec "$vscode/$1" '--extensions-dir $extensionsDir "$@"' >> "$o"
    )
    mkVscWrapper "bin/$executableName"
  '' + (if stdenvNoCC.isDarwin then ''
    mkVscWrapper "Applications/$longName.app/Contents/MacOS/Electron"
    for path in PkgInfo Frameworks Resources _CodeSignature Info.plist; do
      ln -s "$vscode/Applications/$longName.app/Contents/$path" "$out/Applications/$longName.app/Contents/"
    done
  '' else ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/pixmaps"

    ln -sT "$vscode/share/pixmaps/code.png" "$out/share/pixmaps/code.png"
    ln -sT "$vscode/share/applications/$executableName.desktop" "$out/share/applications/$executableName.desktop"
    ln -sT "$vscode/share/applications/$executableName-url-handler.desktop" "$out/share/applications/$executableName-url-handler.desktop"
  '');
}
