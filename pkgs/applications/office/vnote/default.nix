{ stdenv, fetchFromGitHub, qmake, qtbase, qtwebengine, hicolor-icon-theme, makeDesktopItem }:

let
  description = "A note-taking application that knows programmers and Markdown better";
  desktopItem = makeDesktopItem {
    name = "VNote";
    exec = "vnote";
    icon = "vnote";
    comment = description;
    desktopName = "VNote";
    categories = "Office";
  };
in stdenv.mkDerivation rec {
  version = "2.5";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "17nl4z1k24wfl18f6fxs2chsmxc2526ckn5pddi2ckirbiwqwm60";
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
