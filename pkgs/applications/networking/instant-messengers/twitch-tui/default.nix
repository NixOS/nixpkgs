{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "twitch-tui";
<<<<<<< HEAD
  version = "2.5.1";
=======
  version = "2.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-oqsLqmyLrvb8u9cj68OemUfunbP98/BZjmoGl1Mctrk=";
  };

  cargoHash = "sha256-DEHMF6sTH3BF8lqOV5G4F3+Tsafrhzr0YLqSgV3gq9I=";
=======
    hash = "sha256-ecPrG3zZW+tr0LSCMLgGc6w2qmqzZOTAmEB88xKJxvk=";
  };

  cargoHash = "sha256-SQ0anSl/MrSEyfcLbzma3RT2iDqVa0wrcYAmIMysyew=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    changelog = "https://github.com/Xithrius/twitch-tui/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.taha ];
  };
}
