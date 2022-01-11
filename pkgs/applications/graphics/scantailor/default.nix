{ lib, stdenv, fetchFromGitHub, qt4, cmake, libjpeg, libtiff, boost }:

stdenv.mkDerivation rec {
  pname = "scantailor";
  version = "0.9.12.1";

  src = fetchFromGitHub {
    owner = "scantailor";
    repo = "scantailor";
    rev = "RELEASE_${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-Jn8+X737vwaE0ZPYdQv/1SocmWFA74XL90IW8yNiafA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 libjpeg libtiff boost ];

  meta = {
    homepage = "https://scantailor.org/";
    description = "Interactive post-processing tool for scanned pages";

    license = lib.licenses.gpl3Plus;

    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
