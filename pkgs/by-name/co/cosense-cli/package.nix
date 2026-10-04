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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "helpfeel";
    repo = "cosense-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kYEZ67NVgx2Rbn8m99a7xxDcjCzS4NtyvZK6o2d4ak4=";
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-VSpiCxgMTqU0p72x1rGgRokijZD/b5w4HPnlv3d2Tlw=";

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
