{
  buildNpmPackage,
  lib,
  testers,
  shopify-cli,
}:
let
  version = "3.86.1";
in
buildNpmPackage {
  pname = "shopify";
  version = version;

  src = ./manifests;

  npmDepsHash = "sha256-GAE4zfSqk7oM2ecojPC4REFGRdRwvqCnA9L2L7LMIfQ=";
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
