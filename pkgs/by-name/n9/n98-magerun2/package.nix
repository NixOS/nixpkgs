{
  lib,
  fetchFromGitHub,
  php83,
  versionCheckHook,
}:

php83.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-GnyIYgVNPumX+GLgPotSzD6BcUiUTlsfYFwFMX94hEk=";
  };

  vendorHash = "sha256-kF8VXE0K/Gzho5K40H94hXtgSS2rogCtMow2ET8PinU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    teams = [ lib.teams.php ];
  };
})
