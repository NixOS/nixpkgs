{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  exiv2,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlas-file-manager";
  version = "1.3.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AstraSuite";
    repo = "Atlas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6rTlEs/9qHgc+ARVhPiwVwDDePYiMTuKu20NqRhO3SE=";
  };

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail 'app.setApplicationVersion("1.0.0");' 'app.setApplicationVersion("${finalAttrs.version}");'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtmultimedia
    exiv2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ATLAS_VERSION" finalAttrs.version)
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen atlas --version";
    };
  };

  meta = {
    description = "File manager for Caelestia";
    homepage = "https://github.com/AstraSuite/Atlas";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "atlas";
    platforms = lib.platforms.linux;
  };
})
