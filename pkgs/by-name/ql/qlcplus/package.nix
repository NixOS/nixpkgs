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
}:

stdenv.mkDerivation rec {
  pname = "qlcplus";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    hash = "sha256-e8KyuCnzTUz/f6cfT7LyUQ9snaFBnE5WTc4FP7jhdRY=";
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

  postInstall = ''
    ln -sf $out/lib/*/libqlcplus* $out/lib
  '';

  meta = {
    description = "Free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = with lib.maintainers; [
      giomf
    ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://www.qlcplus.org/";
  };
}
