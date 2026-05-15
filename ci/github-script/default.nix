# Type check the CI scripts in ci/github-script using TypeScript
{
  importNpmLock,
  nodejs_24,
  runCommand,
  writeShellScriptBin,
}:
let
  npmDeps = importNpmLock.buildNodeModules {
    npmRoot = ./.;
    nodejs = nodejs_24;
  };

  # Files from ci/ that are referenced by the scripts
  parentFiles = {
    "supportedBranches.js" = ../supportedBranches.js;
  };
in
runCommand "typecheck-ci-scripts"
  {
    nativeBuildInputs = [ nodejs_24 ];
    passthru.driver = writeShellScriptBin "typecheck-ci-scripts" ''
      nix-build --no-out-link "$@" \
        ${toString ./..} -A typecheck-ci-scripts
    '';
  }
  ''
    # Set up directory structure matching the source layout
    mkdir -p github-script
    cp -r ${./.}/* github-script/
    chmod -R u+w github-script
    ln -s ${npmDeps}/node_modules github-script/node_modules

    # Copy files from ci/ that are referenced by the scripts
    ${builtins.concatStringsSep "\n" (
      builtins.attrValues (builtins.mapAttrs (name: path: "cp ${path} ${name}") parentFiles)
    )}

    cd github-script
    node node_modules/typescript/bin/tsc --project jsconfig.json
    echo "typecheck-ci-scripts: ok"
    touch $out
  ''
