{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  cmake,
  pkg-config,
  qt6,
  pcsclite,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ausweisapp";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = finalAttrs.version;
    hash = "sha256-cLKF5QYDPngvN6+3p7B8YO/MYvDfD1fbnyEMZPmjj8w=";
  };

  postPatch = ''
    # avoid runtime QML cache to fix GUI loading issues
    substituteInPlace src/ui/qml/CMakeLists.txt src/ui/qml/modules/CMakeLists.txt \
      --replace-fail NO_CACHEGEN ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  # The build scripts copy the entire translations directory from Qt
  # which ends up being read-only because it's in the store.
  preBuild = ''
    chmod +w resources/translations
  '';

  buildInputs = [
    pcsclite
    qt6.qtscxml
    qt6.qtsvg
    qt6.qttools
    qt6.qtwayland
    qt6.qtwebsockets
  ];

  env.LANG = "C.UTF-8";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen ${finalAttrs.meta.mainProgram} --version";
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Official authentication app for German ID card and residence permit";
    downloadPage = "https://github.com/Governikus/AusweisApp2/releases";
    homepage = "https://www.ausweisapp.bund.de/open-source-software";
    license = lib.licenses.eupl12;
    mainProgram = "AusweisApp";
    maintainers = with lib.maintainers; [ b4dm4n ];
    platforms = lib.platforms.linux;
  };
})
