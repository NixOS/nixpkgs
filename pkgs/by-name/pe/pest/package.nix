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
  vendorHash = "sha256-rOJ6PFp4Xfe89usoH455EAT30d2Tu3zd3+C/6K/kGBw=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = [ lib.maintainers.patka ];
  };
})
