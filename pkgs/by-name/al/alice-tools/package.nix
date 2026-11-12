{
  lib,
  stdenv,
  gitUpdater,
  testers,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  bison,
  flex,
  libiconv,
  libpng,
  libjpeg,
  libwebp,
  zlib,
  withQt5 ? false,
  qt5,
  withQt6 ? false,
  qt6,
}:

assert !(withQt5 && withQt6);

let
  qt = if withQt5 then qt5 else qt6;
  withGUI = withQt5 || withQt6;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "alice-tools" + lib.optionalString withGUI "-qt${lib.versions.major qt.qtbase.version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "nunuhara";
    repo = "alice-tools";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-DazWnBeI5XShkIx41GFZLP3BbE0O8T9uflvKIZUXCHo=";
  };

  postPatch = lib.optionalString (withGUI && withQt6) ''
    # Use Meson's Qt6 module
    substituteInPlace src/meson.build \
      --replace qt5 qt6

    # For some reason Meson uses QMake instead of pkg-config detection method for Qt6 on Darwin, which gives wrong search paths for tools
    export PATH=${qt.qtbase.dev}/libexec:$PATH
  '';

  mesonFlags = lib.optionals (withGUI && withQt6) [
    # Qt6 requires at least C++17, project uses compiler's default, default too old on Darwin & aarch64-linux
    "-Dcpp_std=c++17"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    flex
  ]
  ++ lib.optionals withGUI [
    qt.wrapQtAppsHook
  ];

  buildInputs = [
    libiconv
    libpng
    libjpeg
    libwebp
    zlib
  ]
  ++ lib.optionals withGUI [
    qt.qtbase
  ];

  dontWrapQtApps = true;

  # Default install step only installs a static library of a build dependency
  installPhase = ''
    runHook preInstall

    install -Dm755 src/alice $out/bin/alice
  ''
  + lib.optionalString withGUI ''
    install -Dm755 src/galice $out/bin/galice
    wrapQtApp $out/bin/galice
  ''
  + ''

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command =
        lib.optionalString withGUI "env QT_QPA_PLATFORM=minimal "
        + "${lib.getExe finalAttrs.finalPackage} --version";
    };
  };

  meta = {
    description = "Tools for extracting/editing files from AliceSoft games";
    homepage = "https://github.com/nunuhara/alice-tools";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    changelog = "https://github.com/nunuhara/alice-tools/releases/tag/${finalAttrs.src.tag}";
    mainProgram = if withGUI then "galice" else "alice";
  };
})
