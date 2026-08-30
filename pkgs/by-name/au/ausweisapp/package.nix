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
  llhttp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ausweisapp";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp";
    rev = finalAttrs.version;
    hash = "sha256-rxlJ2+IG0XmZ2Oyfk5n1TGDF76KhLahe8KvJ70QX5tQ=";
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
    llhttp
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
    downloadPage = "https://github.com/Governikus/AusweisApp/releases";
    homepage = "https://www.ausweisapp.bund.de/open-source-software";
    license = lib.licenses.eupl12;
    mainProgram = "AusweisApp";
    maintainers = with lib.maintainers; [ b4dm4n ];
    platforms = lib.platforms.linux;
  };
})
