{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pest";
  version = "2.34.4";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/Ygm/jb08t+0EG4KHM2utAavka28VzmjVU/uXODMFvI=";
  };

  composerLock = ./composer.lock;

  vendorHash = "sha256-RDTmNfXD8Lk50i7dY09JNUgg8hcEM0dtwJnh8UpHgQ4=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
