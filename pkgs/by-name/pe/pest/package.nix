{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pest";
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ddsdVx/Vsg7GG11fGASouBU3HAJLSjs1AQGHx52TWzA=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-4CpyerXmfXbwsNsK16V+GY3Rzo4BfavGpOVITD14p8w=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = [ lib.maintainers.patka ];
  };
})
