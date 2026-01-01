{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
<<<<<<< HEAD
  version = "5.23.2";
=======
  version = "5.23.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ZGGbWRRmotqUwVICdqHRHy2wH8Nb4WRn+6Ape9kxFlY=";
=======
    hash = "sha256-PXMwWsp2dwDj67waT5FXsKMgXnbmNFhHR07Jw7ePkx8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
<<<<<<< HEAD
  vendorHash = "sha256-fQGj673X6Zmm+6jy2WZ8su8zELPlcI6z4u5NbtQ9gAk=";
=======
  vendorHash = "sha256-FxKqFjrgothuWZOJySQ+yV1ygVWrrbv3h0hXAwaqHsQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Adding npm (nodejs) and php composer to path
  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${
        lib.makeBinPath [
          php.packages.composer
          nodejs
        ]
      }
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Laravel application installer";
    homepage = "https://laravel.com/docs#creating-a-laravel-project";
    changelog = "https://github.com/laravel/installer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "laravel";
    maintainers = with lib.maintainers; [ heisfer ];
  };
})
