{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-MzJJkbT3AgSX+lLEfKlfg0zTY/79CcFelOK83NnSWI0=";
  };

  vendorHash = "sha256-4w4HqYSSeVZnsgMGt+m8XN98RuAv7XmVo1vHtEXA0Uk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    maintainers = lib.teams.php.members;
  };
})
