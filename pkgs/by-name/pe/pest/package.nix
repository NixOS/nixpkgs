{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pest";
  version = "3.8.7";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y0FkZhxORkEm1tDTD6ktGr6VvimriPYF+1poGtsly38=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-0fllmZWw5YaHkwnPv6xV/W35oN852j3oyFp5DOIW2So=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = [ lib.maintainers.patka ];
  };
})
