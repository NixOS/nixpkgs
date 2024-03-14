{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pest";
  version = "2.34.2";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tVNF2oC/fLnX10ER9qmWJxMQ/RU9UUQtEi7b1xe094o=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-bFwIRcCqeWcsFsD6wFD+XNe3IMGE3hMg7AU7XaqwtT4=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
