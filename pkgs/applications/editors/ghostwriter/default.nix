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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = version;
    hash = "sha256-8JtCO5jrkbZ4uEM7SALg64L4HSzdzzh7r1pldxzaXeI=";
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];

  buildInputs = [ qtwebengine hunspell ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ cmark multimarkdown pandoc ])
  ];

  meta = with lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = "https://kde.github.io/ghostwriter";
    changelog = "https://github.com/KDE/ghostwriter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
