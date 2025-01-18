{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    tag = finalAttrs.version;
    hash = "sha256-1wHRzh/Fdxdgx70fIPNOIpqBX9IvYPJnV7CZ5hLQ0qE=";
  };

  vendorHash = "sha256-KULTijHG5717dDOfvB4yR+ztrB+mbYaosgmg8aV/GAs=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = with lib; {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = licenses.mit;
    mainProgram = "n98-magerun2";
    maintainers = teams.php.members;
  };
})
