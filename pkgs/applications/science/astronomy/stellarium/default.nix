{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  perl,
  wrapGAppsHook3,
  wrapQtAppsHook,
  qtbase,
  qtcharts,
  qtpositioning,
  qtmultimedia,
  qtserialport,
  qtwayland,
  qtwebengine,
  calcmysky,
  qxlsx,
  indilib,
  libnova,
  qttools,
  exiv2,
  nlopt,
  testers,
  xvfb-run,
  gitUpdater,
  md4c,
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

  # patch from fedora to allow building with Qt 6.10
  patches = [
    (fetchpatch2 {
      url = "https://src.fedoraproject.org/rpms/stellarium/raw/27b05de4be4fa44630c38ffed7f19fe6297e0236/f/stellarium-fix-build-against-qt-6-10.patch";
      hash = "sha256-VYGaXdokTGOK4pa6WBncdJiVmNQFCaFyRa9r3qXHvY0=";
    })
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SET(CMAKE_INSTALL_PREFIX "''${PROJECT_BINARY_DIR}/Stellarium.app/Contents")' \
                'SET(CMAKE_INSTALL_PREFIX "${placeholder "out"}/Applications/Stellarium.app/Contents")'
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "\''${_qt_bin_dir}/../" "${qtmultimedia}/lib/qt-6/"
  '';

  nativeBuildInputs = [
    cmake
    perl
    wrapGAppsHook3
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    qtbase
    qtcharts
    qtpositioning
    qtmultimedia
    qtserialport
    qtwebengine
    calcmysky
    qxlsx
    indilib
    libnova
    exiv2
    md4c
    nlopt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ];

  preConfigure = ''
    export SOURCE_DATE_EPOCH=$(date -d 20${lib.versions.major finalAttrs.version}0101 +%s)
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LC_ALL=en_US.UTF-8
  '';

  # fatal error: 'QtSerialPort/QSerialPortInfo' file not found
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-F${qtserialport}/lib";

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
