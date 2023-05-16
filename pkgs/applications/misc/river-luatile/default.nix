{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, luajit
}:

rustPlatform.buildRustPackage rec {
  pname = "river-luatile";
<<<<<<< HEAD
  version = "0.1.3";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "river-luatile";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ZBytoj4L72TjxJ7vFivjcSO69AcdwKNbXh4rA/bn5iU=";
  };

  cargoHash = "sha256-GcMSglLKuUD3nVj0/8Nbrk4qs5gl5PlCj7r1MYq/vQg=";
=======
    hash = "sha256-flh1zUBranb7w1fQuinHbVRGlVxfl2aKxSwShHFG6tI=";
  };

  cargoHash = "sha256-9YQxa6folwCJNoEa75InRbK1X7cD4F5QGzeGlfsr/5s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    luajit
  ];

  meta = with lib; {
    description = "Write your own river layout generator in lua";
    homepage = "https://github.com/MaxVerevkin/river-luatile";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pinpox ];
  };
}
