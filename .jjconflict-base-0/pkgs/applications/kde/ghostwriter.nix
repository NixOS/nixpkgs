{ lib
, mkDerivation
, extra-cmake-modules
, qttools
, qtwebengine
, kcoreaddons
, kconfigwidgets
, sonnet
, kxmlgui
, hunspell
, cmark
, multimarkdown
, pandoc
}:

mkDerivation {
  pname = "ghostwriter";

  nativeBuildInputs = [ extra-cmake-modules qttools ];

  buildInputs = [
    qtwebengine
    hunspell
    kcoreaddons
    kconfigwidgets
    sonnet
    kxmlgui
  ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ cmark multimarkdown pandoc ])
  ];

  meta = with lib; {
    description = "Cross-platform, aesthetic, distraction-free Markdown editor";
    mainProgram = "ghostwriter";
    homepage = "https://ghostwriter.kde.org/";
    changelog = "https://invent.kde.org/office/ghostwriter/-/blob/master/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda erictapen ];
  };
}
