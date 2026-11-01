{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_24,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "cosense-cli";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "helpfeel";
    repo = "cosense-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QT255tMgK96joW+NdrNoa7O/BWG9vs21lBJ21S6JCtk=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-VnLLjvK4GdCIcSzj3X8FcxlZ8xH+T84AX+Ps7Tr5BWo=";

  __structuredAttrs = true;

  dontNpmBuild = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for reading, searching, and editing Cosense (formerly Scrapbox) pages";
    homepage = "https://github.com/helpfeel/cosense-cli";
    changelog = "https://github.com/helpfeel/cosense-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ conao3 ];
    mainProgram = "cosense";
  };
})
