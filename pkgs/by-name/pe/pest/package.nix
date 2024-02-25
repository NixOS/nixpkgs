{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "pest";
  version = "2.33.4";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9AJww0mynlacBsQvqb++vWn0vsapxFeXsA/tJJEQGFI=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-Z3vmHqySLU0zRqnDoVTt6FURxtJjVOyUXlURSsO6XE8=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = with lib.maintainers; [ patka ];
  };
})
