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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellarium";
  version = "25.1";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rbnGSdzPuFdSqWPaKtF3n4oLZ9l+4jX7KtnmcrTvwbs=";
  };

  patches = [
    # Patch from upstream to fix compilation with Qt 6.9
    (fetchpatch {
      url = "https://github.com/Stellarium/stellarium/commit/bbcd60ae52b6f1395ef2390a2d2ba9d0f98db548.patch";
      hash = "sha256-9VaqLASxn1udUApDZRI5SCqCXNGOHUcdbM+pKhW8ZAg=";
    })

    # Upstream patch to support building with a locally provided md4c package
    (fetchpatch {
      url = "https://github.com/Stellarium/stellarium/commit/972c6ba72f575964fbf2049a22d51b4d1fd3983c.patch";
      hash = "sha256-ef1Jw5NeT0KLVKQt7VcvQh83n2ujMFK+Nv0165ZQ2r8=";
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

  buildInputs =
    [
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

  preConfigure =
    ''
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
