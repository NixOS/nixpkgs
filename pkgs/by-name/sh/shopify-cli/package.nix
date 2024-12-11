{ buildNpmPackage, lib, testers, shopify-cli }:
let
  version = "3.69.3";
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

  npmDepsHash = "sha256-QhbOKOs/0GEOeySG4uROzgtD4o7C+6tS/TAaPcmC3xk=";
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
