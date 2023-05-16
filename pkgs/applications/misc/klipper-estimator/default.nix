{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, pkg-config
, openssl
, libgit2
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "klipper-estimator";
<<<<<<< HEAD
  version = "3.5.0";
=======
  version = "3.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sq0HWK+zH7Rj/XFgMrI4+SVhBXPbvvoSr3A/1Aq/Fa8=";
  };

  cargoHash = "sha256-QHSydaE867HaY7vBoV+v4p7G5qbQy5l3TemD3k41T4A=";
=======
    hash = "sha256-bWKR7+eX7tcc9KywKIg6CY+3qALPqOSSiSSlK44iTDQ=";
  };

  cargoHash = "sha256-cPdFRBU8B4C2el9N069QooiJdpopns8RJEyavemYdUc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libgit2 Security ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Tool for determining the time a print will take using the Klipper firmware";
    homepage = "https://github.com/Annex-Engineering/klipper_estimator";
    changelog = "https://github.com/Annex-Engineering/klipper_estimator/releases/tag/v${version}";
    mainProgram = "klipper_estimator";
    license = licenses.mit;
    maintainers = with maintainers; [ tmarkus ];
  };
}
