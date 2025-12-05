{
  buildNpmPackage,
  lib,
  testers,
  shopify-cli,
}:
let
  version = "3.87.4";
in
buildNpmPackage {
  pname = "shopify";
  version = version;

  src = ./manifests;

  npmDepsHash = "sha256-dvtDhzqNDKE63u1NW6HO0QbijGtX0lGcCbQ7rrnnjwM=";
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
    maintainers = with lib.maintainers; [
      fd
      onny
    ];
  };
}
