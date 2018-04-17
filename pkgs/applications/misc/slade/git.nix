{ stdenv, fetchFromGitHub, cmake, pkgconfig, wxGTK, gtk2, sfml, fluidsynth, curl, freeimage, ftgl, glew, zip }:

stdenv.mkDerivation {
  name = "slade-git-3.1.2.2018.01.29";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "f7409c504b40c4962f419038db934c32688ddd2e";
    sha256 = "14icxiy0r9rlcc10skqs1ylnxm1f0f3irhzfmx4sazq0pjv5ivld";
  };

  cmakeFlags = ["-DNO_WEBVIEW=1"];
  nativeBuildInputs = [ cmake pkgconfig zip ];
  buildInputs = [ wxGTK gtk2 sfml fluidsynth curl freeimage ftgl glew ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Doom editor";
    homepage = http://slade.mancubus.net/;
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ ertes ];
  };
}
