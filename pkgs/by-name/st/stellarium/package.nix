{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  perl,
  wrapGAppsHook3,
  qt6,
  qt6Packages,
  calcmysky,
  indilib,
  libnova,
  exiv2,
  nlopt,
  testers,
  xvfb-run,
  gitUpdater,
  md4c,
  withQtWebEngine ? lib.meta.availableOn stdenv.hostPlatform qt6.qtwebengine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellarium";
  version = "25.3";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9uQ6u1+dSszmKG8eY6kSXhqsCPRGw6tulCTCrLByIxc=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/stellarium/-/raw/ab559b6e9349569278f83c2dfc83990e971a8cb2/qt-6.10.patch";
      hash = "sha256-a7zC9IQOj93VnPy8Bj/fLe4oJux7I4Edgj5OaKI4TZU=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Applications/Stellarium.app/Contents")'
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "\''${_qt_bin_dir}/../" "${qt6.qtmultimedia}/lib/qt-6/"
  '';

  nativeBuildInputs = [
    cmake
    perl
    wrapGAppsHook3
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qtpositioning
    qt6.qtmultimedia
    qt6.qtserialport
    calcmysky
    qt6Packages.qxlsx
    indilib
    libnova
    exiv2
    md4c
    nlopt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ]
  ++ lib.optionals withQtWebEngine [
    qt6.qtwebengine
  ];

  preConfigure = ''
    export SOURCE_DATE_EPOCH=$(date -d 20${lib.versions.major finalAttrs.version}0101 +%s)
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LC_ALL=en_US.UTF-8
  '';

  # fatal error: 'QtSerialPort/QSerialPortInfo' file not found
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-F${qt6.qtserialport}/lib";

  dontWrapGApps = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper $out/Applications/Stellarium.app/Contents/MacOS/Stellarium $out/bin/stellarium
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = ''
        # Create a temporary home directory because stellarium aborts with an
        # error if it can't write some configuration files.
        tmpdir=$(mktemp -d)

        # stellarium can't be run in headless mode, therefore we need xvfb-run.
        HOME="$tmpdir" ${lib.getExe xvfb-run} stellarium --version
      '';
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Free open-source planetarium";
    mainProgram = "stellarium";
    homepage = "https://stellarium.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kilianar ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
