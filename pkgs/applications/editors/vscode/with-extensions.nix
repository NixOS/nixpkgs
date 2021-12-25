{ lib
, stdenvNoCC
, symlinkJoin
, vscode
, runtimeShell
, vscodeExtensions ? [ ]
# TODO:change defaults when one of those issues is resolved:
# https://github.com/rpodgorny/unionfs-fuse/issues/101
# https://github.com/trapexit/mergerfs/issues/115
, mountPosition ? if stdenvNoCC.isDarwin then "none" else "above"
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

assert lib.assertOneOf "mountPosition" mountPosition [ "above" "below" "none" ];

# When no extensions are requested, we simply don't build

if mountPosition != "none" && vscodeExtensions == [ ] then vscode else

let
  # if vscode is itself another vscode-with-extensions we avoid to build it too
  canFlatten = mountPosition == vscode.mountPosition or "" && vscode ? vscodeExtensions && vscode ? vscode;
  _vscode = if canFlatten then vscode.vscode else vscode;
  combinedExtensionsDrv = symlinkJoin {
    name = "vscode-extensions";
    paths = map
      (p: "${p}/share/vscode/extensions")
      (vscodeExtensions ++ (lib.optionals canFlatten vscode.vscodeExtensions));
  };
  setExtDir = ''
    export VSCODE_EXTENSIONS="${combinedExtensionsDrv}"
  '';
in

stdenvNoCC.mkDerivation rec {
  dontPatchELF = true;
  dontStrip = true;
  pname = "${_vscode.pname}-with-extensions";

  vscode = _vscode;
  inherit (_vscode)
    meta extensionHomePath executableName
    longName shortName userHomePath version;
  passthru = {
    inherit vscodeExtensions mountPosition;
  };

  passAsFile = [ "buildCommand" "vscSh" ];
  vscSh = if mountPosition == "none" then setExtDir else ''
    homeExt="''${VSCODE_EXTENSIONS:-$HOME/${extensionHomePath}}"
    mkdir -p "$homeExt"
    # assume $out is unique enough it can replace a tmpdir suffix
    export VSCODE_EXTENSIONS="''${XDG_RUNTIME_DIR:-''${TEMPDIR:-/tmp}/$PID}@out@"
    # avoid remounting after closing and reopening vscode
    if ! (mount | grep "$VSCODE_EXTENSIONS" > /dev/null)
    then
      mkdir -p "$VSCODE_EXTENSIONS"
      ${mergerfs}/bin/mergerfs \
        -o use_ino,cache.files=partial,dropcacheonclose=true,category.create=mfs \
        ${
          if mountPosition =="above" then
            ''"${combinedExtensionsDrv}=RO:$homeExt=RW"''
          else
            ''"$homeExt=RW:${combinedExtensionsDrv}=RO"''
        } "$VSCODE_EXTENSIONS" || ${setExtDir}
    fi
  '';
  buildCommand = ''
    mkVscWrapper()(
      o="$out/$1"
      install -Dm0777 "$vscShPath" "$o"
      sed -i "1i#! ${runtimeShell}\n" "$o"
      echo exec "$vscode/$1" '"$@"' >> "$o"
      substituteInPlace "$o" --subst-var out
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
