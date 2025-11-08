{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "deployer";
  version = "7.5.12";

  src = fetchFromGitHub {
    owner = "deployphp";
    repo = "deployer";
    rev = "7b108897baa94b8ac438c821ec1fb815d95eba77";
    hash = "sha256-wtkixHexsJNKsLnnlHssh0IzxwWYMPKDcaf/D0zUNKk=";
  };

  vendorHash = "sha256-/bf1rvoG1N6GNqisBwMqY05qhTsy7gMeWXarXgElU/M=";

  meta = {
    changelog = "https://github.com/deployphp/deployer/releases/tag/v${finalAttrs.version}";
    description = "PHP deployment tool with support for popular frameworks out of the box";
    homepage = "https://deployer.org/";
    license = lib.licenses.mit;
    mainProgram = "dep";
    teams = [ lib.teams.php ];
  };
})
