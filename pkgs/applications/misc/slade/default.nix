{ stdenv, fetchFromGitHub, cmake, pkgconfig, zip, which, wrapGAppsHook
, wxGTK, sfml, fluidsynth, curl, freeimage, ftgl, glew
}:

stdenv.mkDerivation rec {
  pname = "slade";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = version;
    sha256 = "1yfq7ghg9whys7a07xfcza8rwyfhnrcz6qi5bay1ilj3ml4m12zy";
  };

  nativeBuildInputs = [ cmake pkgconfig zip which wrapGAppsHook ];
  buildInputs = [ wxGTK wxGTK.gtk sfml fluidsynth curl freeimage ftgl glew ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
