{ buildNpmPackage, lib, testers, shopify-cli }:
let
  version = "3.67.1";
in
buildNpmPackage {
  pname = "shopify";
  version = version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = with lib.fileset; unions [
      ./package.json
      ./package-lock.json
    ];
  };

  npmDepsHash = "sha256-jb87K1tCMYgWrsAgzvdHW8ChB+dvc9yNM0hqajy8Rbo=";
  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = shopify-cli;
      command = "shopify version";
    };
  };

  meta = {
    platforms = lib.platforms.all;
    mainProgram = "shopify";
    description = "CLI which helps you build against the Shopify platform faster";
    homepage = "https://github.com/Shopify/cli";
    changelog = "https://github.com/Shopify/cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fd onny ];
  };
}
