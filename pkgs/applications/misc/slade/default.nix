{ stdenv, fetchFromGitHub, cmake, pkgconfig, wxGTK, gtk2, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip }:

stdenv.mkDerivation rec {
  name = "slade-${version}";
  version = "3.1.1.4";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "0c2yjkpcwxkid1wczmc9f16x1p40my8jv61jc93ldgjzcprmrpn8";
  };

  nativeBuildInputs = [ cmake pkgconfig zip ];
  buildInputs = [ wxGTK gtk2 sfml fluidsynth curl freeimage ftgl glew ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
