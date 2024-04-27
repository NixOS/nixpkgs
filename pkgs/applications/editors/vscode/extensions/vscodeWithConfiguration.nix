# wrapper over vscode to control extensions per project (extensions folder will be created in execution path)
{ lib
, writeShellScriptBin
, extensionsFromVscodeMarketplace
, vscodeDefault
}:
## User input
{ vscode ? vscodeDefault
# extensions to be symlinked into the project's extensions folder
, nixExtensions        ? []
# extensions to be copied into the project's extensions folder
, mutableExtensions    ? []
, vscodeExtsFolderName ? ".vscode-exts"
, user-data-dir ? ''"''${TMP}vscodeWithConfiguration/vscode-data-dir"''
}:
let
  nixExtsDrvs = extensionsFromVscodeMarketplace nixExtensions;
  mutExtsDrvs = extensionsFromVscodeMarketplace mutableExtensions;
  mutableExtsPaths = lib.forEach mutExtsDrvs ( e:
  {
    origin = "${e}/share/vscode/extensions/${e.vscodeExtUniqueId}";
    target = ''${vscodeExtsFolderName}/${e.vscodeExtUniqueId}-${(lib.findSingle (ext: "${ext.publisher}.${ext.name}" == e.vscodeExtUniqueId) "" "m" mutableExtensions ).version}'';
  }
  );

  #removed not defined extensions
  rmExtensions =  lib.optionalString (nixExtensions++mutableExtensions != []) ''
    find ${vscodeExtsFolderName} -mindepth 1 -maxdepth 1 ${
        lib.concatMapStringsSep " " (e : "! -iname ${e.publisher}.${e.name} ") nixExtensions
        +
        lib.concatMapStringsSep " " (e : "! -iname ${e.publisher}.${e.name}-${e.version} ") mutableExtensions
      } -exec rm -rf {} \;
  '';
  #copy mutable extension out of the nix store
  cpExtensions = ''
    ${lib.concatMapStringsSep "\n" (e : "ln -sfn ${e}/share/vscode/extensions/* ${vscodeExtsFolderName}/") nixExtsDrvs}
    ${lib.concatMapStringsSep "\n" (ePath : ''
      if [ ! -d ${ePath.target} ]; then
        cp -a ${ePath.origin} ${ePath.target}
        chmod -R u+rwx ${ePath.target}
      fi
      '') mutableExtsPaths}
  '';
in
  writeShellScriptBin "code" ''
    if ! [[ "$@" =~ "--list-extension" ]]; then
      mkdir -p "${vscodeExtsFolderName}"
      ${rmExtensions}
      ${cpExtensions}
    fi
    ${vscode}/bin/code --extensions-dir "${vscodeExtsFolderName}" ${
      lib.optionalString (user-data-dir != "") "--user-data-dir ${user-data-dir}"
      } "$@"
  ''
