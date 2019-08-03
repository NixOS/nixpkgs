{ stdenv, fetchFromGitHub, qmake, qtbase, qtwebengine, hicolor-icon-theme, makeDesktopItem }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in stdenv.mkDerivation rec {
  version = "2.6";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "10lnzzwz7fjj55kbn3j6gdl9yi6a85mdjis586p3zcc4830mlv91";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine hicolor-icon-theme ];

  meta = with stdenv.lib; {
    inherit description;
    homepage = "https://tamlok.github.io/vnote";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
