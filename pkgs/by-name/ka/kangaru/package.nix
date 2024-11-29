{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kangaru";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "gracicot";
    repo = "kangaru";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-30gmNo68cDGmGjS75KySyORC6s1NBI925QuZyOv3Kag=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = {
    description = "Inversion of control container for C++11, C++14 and later";
    homepage = "https://github.com/gracicot/kangaru";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
  };
})
