{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule rec {
  pname = "nom";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "guyfedwards";
    repo = "nom";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DoSTBFRGJ7oUjUaiszO87b+0v1sBgLmL24Zd/YaMMXQ=";
=======
    hash = "sha256-3jkHwHEuwq+KmPyDqdRsHtU4HJiBSogifufUiFpsYkI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-d5KTDZKfuzv84oMgmsjJoXGO5XYLVKxOB5XehqgRvYw=";

  ldflags = [
    "-X 'main.version=${version}'"
  ];

<<<<<<< HEAD
  # only run xdg-specific test on linux
  checkFlags = lib.optional stdenv.hostPlatform.isDarwin "-skip=^TestNewDefaultWithXDGConfigHome$";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/guyfedwards/nom";
    changelog = "https://github.com/guyfedwards/nom/releases/tag/v${version}";
    description = "RSS reader for the terminal";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nadir-ishiguro
      matthiasbeyer
    ];
    mainProgram = "nom";
  };
}
