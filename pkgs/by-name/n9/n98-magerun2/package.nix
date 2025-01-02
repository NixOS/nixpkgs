{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    rev = finalAttrs.version;
    hash = "sha256-1wHRzh/Fdxdgx70fIPNOIpqBX9IvYPJnV7CZ5hLQ0qE=";
  };

  vendorHash = "sha256-KULTijHG5717dDOfvB4yR+ztrB+mbYaosgmg8aV/GAs=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    maintainers = lib.teams.php.members;
  };
})
