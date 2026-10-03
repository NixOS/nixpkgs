{
  lib,
  vscode-utils,
  bashdb,
  coreutils,
  procps,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "bash-debug";
    publisher = "rogalmic";
    version = "0.3.9";
    hash = "sha256-f8FUZCvz/PonqQP9RCNbyQLZPnN5Oce0Eezm/hD19Fg=";
  };

  postPatch = ''
    rm -r bashdb_dir

    substituteInPlace out/extension.js \
      --replace-fail 'path_1.normalize(path_1.join(__dirname, "..", "bashdb_dir", "bashdb"))' '"${lib.getExe bashdb}"' \
      --replace-fail 'path_1.normalize(path_1.join(__dirname, "..", "bashdb_dir"))' '"${bashdb}/share/bashdb"' \
      --replace-fail 'config.pathCat = "cat"' 'config.pathCat = "${lib.getExe' coreutils "cat"}"' \
      --replace-fail 'config.pathMkfifo = "mkfifo"' 'config.pathMkfifo = "${lib.getExe' coreutils "mkfifo"}"' \
      --replace-fail 'config.pathPkill = "pkill"' 'config.pathPkill = "${lib.getExe' procps "pkill"}"'
  '';

  meta = {
    description = "Visual Studio Code extension for debugging bash scripts using bashdb";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug";
    homepage = "https://github.com/rogalmic/vscode-bash-debug";
    changelog = "https://github.com/rogalmic/vscode-bash-debug/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
  };
}
