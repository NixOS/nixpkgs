{ stdenv, fetchFromGitHub, cmake, pkgconfig, fltk, libGL }:

with stdenv.lib;

stdenv.mkDerivation rec {

  pname = "freediag";
  version = "unstable-2019-02-18";

  src = fetchFromGitHub {
    owner = "fenugrec";
    repo = "freediag";
    rev = "c33eab1aa1c6840676b12eca9f0cddfdf7506523";
    sha256 = "1gg0210rhwlfjx8dqs3ivpxcdvwhn57p228v79zz58ljnlm7766p";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ fltk libGL ];

  cmakeFlags = [ "-DBUILD_GUI=1" ];

  meta = {
    description = "Free diagnostic software for OBD-II compliant motor vehicles";
    homepage = https://freediag.sourceforge.net/;
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
    license = stdenv.lib.licenses.gpl3;
  };
}
