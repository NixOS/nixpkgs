{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  pcsclite,
  qtscxml,
  qtsvg,
  qttools,
  qtwayland,
  qtwebsockets,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ausweisapp";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "Governikus";
    repo = "AusweisApp2";
    rev = finalAttrs.version;
    hash = "sha256-YRRm8/yDwQIUjzqYzlqij8h2ri39Q7L8jVh5fgrZbGs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  # The build scripts copy the entire translations directory from Qt
  # which ends up being read-only because it's in the store.
  preBuild = ''
    chmod +w resources/translations
  '';

  buildInputs = [
    pcsclite
    qtscxml
    qtsvg
    qttools
    qtwayland
    qtwebsockets
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "QT_QPA_PLATFORM=offscreen ${finalAttrs.meta.mainProgram} --version";
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
