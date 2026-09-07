{
  lib,
  php,
  fetchFromGitHub,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "deployer";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "deployphp";
    repo = "deployer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mbqwAYfEiJB1ELkxQwuMVmgXZZLi9jLjg33o0ZfgT4Y=";
  };

  composerLock = ./composer.lock;

  vendorHash = "sha256-X30D05d0PCmw2tHN7PC9PiAXVlnI6SkQg2l7G+tZ4Mo=";

  meta = {
    changelog = "https://github.com/deployphp/deployer/releases/tag/v${finalAttrs.version}";
    description = "PHP deployment tool with support for popular frameworks out of the box";
    homepage = "https://deployer.org/";
    license = lib.licenses.mit;
    mainProgram = "dep";
    teams = [ lib.teams.php ];
  };
})
