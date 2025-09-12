{
  lib,
  stdenv,
  fetchFromGitHub,
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
  version = "25.2";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2QK9dHflCdmDrRXEHCBpuJR73jsMz9D9lJNa1pbfrTs=";
  };

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
