{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
=======
, stdenv
, rustPlatform
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ADVF+Kb0DDiR3dS43uzhefFFEg1O8IC22i5fmziEp6I=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_6
  ];

  cargoHash = "sha256-XBBZ56jvBtYI5J/sSc4ckk/KXzCHNgM9A4jGolGKh2E=";
=======
    hash = "sha256-oUcQKpZqqb8wZDpdFfpxLpwdfQlokJE5bsoPwxh+JMM=";
  };

  cargoHash = "sha256-ZFrIlNysjlXI8n78N2Hkff6gAplipxSQXUWG8HJq8fs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
<<<<<<< HEAD
    changelog = "https://github.com/Piturnah/gex/releases/tag/${src.rev}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 evanrichter piturnah ];
=======
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
