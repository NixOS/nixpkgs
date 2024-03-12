{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pest";
  version = "2.34.1";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-499DHFrPcWl6TwycZidGzLqLztmVkgC3jzHZV69p7kE=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-Ofz8v3gUuZryN5z6CBfxm+UQ8z0aTkkum1am5x1LicA=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
