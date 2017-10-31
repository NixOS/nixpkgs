{ stdenv, lib, fetchurl, runCommand, buildEnv, vscode, which, writeScript
, vscodeExtensions ? [] }:

/*
  `vscodeExtensions`
   :  A set of vscode extensions to be installed alongside the editor. Here's a an
      example:

      ~~~
      vscode-with-extensions.override {

        # When the extension is already available in the default extensions set.
        vscodeExtensions = with vscode-extensions; [
          bbenoist.Nix
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

  wrappedPkgVersion = lib.getVersion vscode;
  wrappedPkgName = lib.removeSuffix "-${wrappedPkgVersion}" vscode.name;

  combinedExtensionsDrv = buildEnv {
    name = "${wrappedPkgName}-extensions-${wrappedPkgVersion}";
    paths = vscodeExtensions;
  };

  wrappedExeName = "code";
  exeName = wrappedExeName;

  wrapperExeFile = writeScript "${exeName}" ''
    #!${stdenv.shell}
    exec ${vscode}/bin/${wrappedExeName} \
      --extensions-dir "${combinedExtensionsDrv}/share/${wrappedPkgName}/extensions" \
      "$@"
  '';

in

# When no extensions are requested, we simply redirect to the original
# non-wrapped vscode executable.
runCommand "${wrappedPkgName}-with-extensions-${wrappedPkgVersion}" {
  buildInputs = [ vscode which ];
  dontPatchELF = true;
  dontStrip = true;
  meta = vscode.meta;
} ''
  mkdir -p "$out/bin"
  ${if [] == vscodeExtensions
    then ''
      ln -sT "${vscode}/bin/${wrappedExeName}" "$out/bin/${exeName}"
    ''
    else ''
      ln -sT "${wrapperExeFile}" "$out/bin/${exeName}"
    ''}
''
