{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pest";
  version = "2.34.5";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rRXRtcjQUCx8R5sGRBUwlKtog6jQ1WaOu225npM6Ct8=";
  };

  composerLock = ./composer.lock;

  vendorHash = "sha256-skNf6bUyGUN/F9Ffpz325napOmPINYk1TyUyYqWmwRM=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
