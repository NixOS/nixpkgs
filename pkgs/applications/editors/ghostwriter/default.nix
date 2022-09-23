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
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    hash = "sha256-YmZrT/KZUa34A0mMDM423GL99BDLrqrio7gNEW833SI=";
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];

  buildInputs = [ qtwebengine hunspell ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ cmark multimarkdown pandoc ])
  ];

  meta = with lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    changelog = "https://github.com/wereturtle/ghostwriter/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
