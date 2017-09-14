{ stdenv, fetchFromGitHub, cmake, pkgconfig, wxGTK, gtk2, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip }:

stdenv.mkDerivation rec {
  name = "slade-${version}";
  version = "3.1.1.5";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "0mdn59jm6ab4cdh99bgvadif3wdlqmk5mq635gg7krq35njgw6f6";
  };

  nativeBuildInputs = [ cmake pkgconfig zip ];
  buildInputs = [ wxGTK gtk2 sfml fluidsynth curl freeimage ftgl glew ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = http://slade.mancubus.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
