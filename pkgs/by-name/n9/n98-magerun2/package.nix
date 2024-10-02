{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "n98-magerun2";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "netz98";
    repo = "n98-magerun2";
    rev = finalAttrs.version;
    hash = "sha256-OPvyZ0r7Zt4PC+rmRtBm9EkbaE4PeovnUHrhzXUqT8E=";
  };

  vendorHash = "sha256-E2V5ARNCmGOmGGctfcjpW49cxFBcWyJEodBNjHhKQ+w=";

  meta = {
    changelog = "https://magerun.net/category/magerun/";
    description = "Swiss army knife for Magento2 developers";
    homepage = "https://magerun.net/";
    license = lib.licenses.mit;
    mainProgram = "n98-magerun2";
    maintainers = lib.teams.php.members;
  };
})
