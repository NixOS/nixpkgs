{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs_26,
}:

buildNpmPackage (finalAttrs: {
  pname = "paseo-hub";
  version = "0.12.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "getpaseo";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KzNym+kvRwwgsZryDTrhmarOAt8YQS1eTfCzPa4l1s=";
  };

  nodejs = nodejs_26;
  npmDepsHash = "sha256-yEkTWWmtfO+G4vqBuL8wcGP3jwLqZ7KqGHmFEqv7gLM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-hosted automation for Paseo daemons";
    homepage = "https://github.com/getpaseo/hub";
    changelog = "https://github.com/getpaseo/hub/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ adamcstephens ];
    mainProgram = "paseo-hub";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
