{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, qtwebengine
, hunspell
, cmark
, multimarkdown
, pandoc
}:

mkDerivation rec {
  pname = "ghostwriter";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    sha256 = "sha256-kNt0IIAcblDJ81ENIkoJuJvrI+F+fdVgWUJ6g1YpjqU=";
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];

  buildInputs = [ qtwebengine hunspell ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ cmark multimarkdown pandoc ])
  ];

  meta = with lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
