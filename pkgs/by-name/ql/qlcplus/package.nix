{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  udevCheckHook,
  udev,
  qt6,
  alsa-lib,
  ola,
  libftdi1,
  libusb1,
  libsndfile,
  fftw,
  libgpiod,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "qlcplus";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    hash = "sha256-55Jy4t60Lc6YOGko6fW/pUjS5uAiNhVDn4bm8LBWkzI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    udevCheckHook
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    udev
    alsa-lib
    ola
    libftdi1
    libusb1
    libsndfile
    fftw
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libgpiod ]
  ++ (with qt6; [
    qtbase
    qtdeclarative
    qtmultimedia
    qtserialport
    qtsvg
    qttools
    qtwebsockets
    qt3d
  ]);

  postPatch = ''
    patchShebangs .

    # Drop -Werror; newer Qt/compilers emit new warnings (e.g. [[nodiscard]] QFile::open)
    substituteInPlace variables.cmake --replace-fail 'set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -Werror")' ""

    # Drop hardcoded "/usr" prefix so files install to $out instead of $out/usr
    substituteInPlace variables.cmake --replace-fail 'set(INSTALLROOT "/usr")' 'set(INSTALLROOT "")'

    # Keep our CMAKE_INSTALL_LIBDIR instead of recomputing it, which picks lib64
    # and leaves the binary unable to find libqlcplusengine5.so
    substituteInPlace variables.cmake \
      --replace-fail 'unset(CMAKE_INSTALL_LIBDIR CACHE)' "" \
      --replace-fail 'unset(CMAKE_INSTALL_LIBDIR)' ""
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Upstream ships these commented out. They drive DMX over a serial port
    # (e.g. Raspberry Pi DMX HATs) and take triggers from GPIO pins.
    substituteInPlace plugins/CMakeLists.txt \
      --replace-fail '#    add_subdirectory(uart)' 'add_subdirectory(uart)' \
      --replace-fail '#    add_subdirectory(gpio)' 'add_subdirectory(gpio)'
  '';

  cmakeFlags = [
    # Use the QML UI instead of the legacy Qt Widgets UI
    (lib.cmakeBool "qmlui" true)
    # Install prefix, prepended to INSTALLROOT and paths like the udev rules dir
    (lib.cmakeFeature "INSTALL_ROOT" (placeholder "out"))
    # Keep libdir relative, otherwise INSTALLROOT doubles up the absolute $out/lib
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    # Tags look like QLC+_5.3.0
    extraArgs = [ "--version-regex=^QLC\\+_(.*)$" ];
  };

  meta = {
    description = "Free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = with lib.maintainers; [
      giomf
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://www.qlcplus.org/";
    mainProgram = "qlcplus5";
  };
}
