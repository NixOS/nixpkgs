{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  cmake,
  gettext,
  itstool,
  kdePackages,
  libx11,
  libxi,
  libxtst,
  nix-update-script,
  qt6,
  udevCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "antimicrox";
  version = "3.6.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AntiMicroX";
    repo = "antimicrox";
    tag = finalAttrs.version;
    hash = "sha256-Hy0AHg3foZnIbN4Xx8kwYhbg+Z+cjdop6lYdgYPRyts=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"/usr/lib/udev/rules.d/"' "\"$out/lib/udev/rules.d/\""
  '';

  nativeBuildInputs = [
    cmake
    gettext
    itstool
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    libx11
    libxi
    libxtst
    qt6.qtbase
    SDL2
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6_BY_DEFAULT" true)
    (lib.cmakeBool "CHECK_FOR_UPDATES" false)
    (lib.cmakeFeature "ANTIMICROX_PKG_VERSION" finalAttrs.version)
  ];

  # upstream tests are Qt5-only and not built in CI
  doCheck = false;
  doInstallCheck = true;

  nativeInstallCheckInputs = [
    udevCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  preInstallCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  versionCheckKeepEnvironment = "HOME QT_QPA_PLATFORM";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GUI for mapping keyboard and mouse controls to a gamepad";
    homepage = "https://github.com/AntiMicroX/antimicrox";
    changelog = "https://github.com/AntiMicroX/antimicrox/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "antimicrox";
  };
})
