{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtwebengine, hicolor-icon-theme }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in mkDerivation rec {
  version = "2.7.2";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "0mk1ingcyznpwq4bfkxa8nx9yx5y3kgsmr4qffriq7bh1cx9dwjy";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine hicolor-icon-theme ];

  meta = with lib; {
    inherit description;
    homepage = "https://tamlok.github.io/vnote";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
