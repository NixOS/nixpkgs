{
  lib,
  mkDerivation,
  extra-cmake-modules,
  qttools,
  qtwebengine,
  kcoreaddons,
  kconfigwidgets,
  sonnet,
  kxmlgui,
  hunspell,
  cmark,
  multimarkdown,
  pandoc,
}:

mkDerivation {
  pname = "ghostwriter";

  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];

  buildInputs = [
    qtwebengine
    hunspell
    kcoreaddons
    kconfigwidgets
    sonnet
    kxmlgui
  ];

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      cmark
      multimarkdown
      pandoc
    ])
  ];

  meta = {
    description = "Cross-platform, aesthetic, distraction-free Markdown editor";
    mainProgram = "ghostwriter";
    homepage = "https://ghostwriter.kde.org/";
    changelog = "https://invent.kde.org/office/ghostwriter/-/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dotlambda
      erictapen
    ];
  };
}
