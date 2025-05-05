{
  cmake,
  fetchFromGitLab,
  lib,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  stdenv,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qt6ct";
  version = "0.10";

  src = fetchFromGitLab {
    domain = "www.opencode.net";
    owner = "trialuser";
    repo = "qt6ct";
    tag = finalAttrs.version;
    hash = "sha256-o2k/b4AGiblS1CkNInqNrlpM1Y7pydIJzEVgVd3ao50=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtwayland
  ];

  postPatch = ''
    substituteInPlace src/qt6ct-qtplugin/CMakeLists.txt src/qt6ct-style/CMakeLists.txt \
      --replace-fail "\''${PLUGINDIR}" "$out/${qtbase.qtPluginPrefix}"
  '';

  meta = {
    description = "Qt6 Configuration Tool";
    homepage = "https://www.opencode.net/trialuser/qt6ct";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Flakebi
      Scrumplex
    ];
    mainProgram = "qt6ct";
  };
})
