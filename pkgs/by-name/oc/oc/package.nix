{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  nodejsInstallExecutables,
  nodejsInstallManuals,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oc";
  version = "0.5.8";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "only-cli";
    repo = "oc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fCQ+bwlkmb1d9uO6ux+h69LgKX57GQaTiY7tQgX7+q8=";
  };

  nativeBuildInputs = [
    nodejs
    nodejsInstallExecutables
    nodejsInstallManuals
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
    npmHooks.npmInstallHook
  ];

  npmBuildScript = "build";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Lsv5/5n592oqeo3Hq5JMXg+ADh6AajhGD0MrxUU6SFs=";
  };

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn any website into a compact CLI tailored for AI agents. Browse the web in hundreds of tokens, not tens of thousands";
    homepage = "https://github.com/only-cli/oc";
    changelog = "https://github.com/only-cli/oc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "oc";
    platforms = lib.platforms.all;
  };
})
