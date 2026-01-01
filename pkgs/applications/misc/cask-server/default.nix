{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
}:

mkDerivation rec {
  pname = "cask-server";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Nitrux";
    repo = "cask-server";
    tag = "v${version}";
    sha256 = "sha256-XUgLtZMcvzGewtUcgu7FbBCn/1zqOjWvw2AI9gUwWkc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

<<<<<<< HEAD
  meta = {
    description = "Public server and API to interface with Cask features";
    mainProgram = "CaskServer";
    homepage = "https://github.com/Nitrux/cask-server";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Public server and API to interface with Cask features";
    mainProgram = "CaskServer";
    homepage = "https://github.com/Nitrux/cask-server";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bsd2
      lgpl21Plus
      cc0
    ];
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ onny ];
=======
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}
