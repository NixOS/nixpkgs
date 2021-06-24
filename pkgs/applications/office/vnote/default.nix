{ lib, mkDerivation, fetchFromGitHub, qmake, qtbase, qtwebengine }:

let
  description = "A note-taking application that knows programmers and Markdown better";
in mkDerivation rec {
  version = "2.10";
  pname = "vnote";

  src = fetchFromGitHub {
    owner = "tamlok";
    repo = "vnote";
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "EeeVGnKI0irLO1zJQxlVlIUhqG987JIgxNvKpUgLxUQ=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine ];

  meta = with lib; {
    inherit description;
    homepage = "https://tamlok.github.io/vnote";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.kuznero ];
  };
}
