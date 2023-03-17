{lib, stdenv, fetchFromGitHub, flex, bison, qt4, libX11, cmake, gperf, adms }:

stdenv.mkDerivation rec {
  version = "0.0.19";
  pname = "qucs";

  src = fetchFromGitHub {
    owner = "Qucs";
    repo = "qucs";
    rev = "qucs-${version}";
    sha256 = "106h3kjyg7c0hkmzkin7h8fcl32n60835121b2qqih8ixi6r5id6";
  };

  QTDIR=qt4;

  patches = [
    ./cmakelists.patch
  ];

  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ qt4 libX11 gperf adms ];

  meta = {
    description = "Integrated circuit simulator";
    homepage = "https://qucs.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
  };
}
