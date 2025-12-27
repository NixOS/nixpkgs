{
  lib,
  stdenv,
  fetchFromGitea,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keyoxide-cli";
  version = "0.4.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "keyoxide";
    repo = "keyoxide-cli";
    tag = finalAttrs.version;
    hash = "sha256-lQEvtqFq3OBlXdYdrhMsAns4kimR2RfRx3VFNy4nEu8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-UxP5NkmA3MsrXhoa+JviDdW19HKE6Xpj1dkN7h0ggck=";
  };

  yarnBuildScript = "prettier";
  yarnBuildFlags = "src/commands.js";

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://codeberg.org/keyoxide/keyoxide-cli/releases/tag/${finalAttrs.version}";
    description = "Command-line interface to locally verify decentralized identities";
    homepage = "https://codeberg.org/keyoxide/keyoxide-cli";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "keyoxide";
  };
})
