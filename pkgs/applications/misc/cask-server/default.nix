{ lib
, pkgs
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
}:

mkDerivation rec {
  pname = "cask-server";
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    sha256 = "sha256-XUgLtZMcvzGewtUcgu7FbBCn/1zqOjWvw2AI9gUwWkc=";
=======
    sha256 = "sha256-/dDrJcyp6+r6G3E0KPOEH0hEY9C5XIg1z2gRZV3GZcg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Public server and API to interface with Cask features";
    homepage = "https://github.com/Nitrux/cask-server";
    license = with licenses; [
      bsd2
      lgpl21Plus
      cc0
    ];
    maintainers = with maintainers; [ onny ];
  };

}
