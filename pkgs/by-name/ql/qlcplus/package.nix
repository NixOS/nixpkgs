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

    # Fix build failure caused by newer compilers/Qt turning on additional
    # warnings (e.g. -Wunused-result for [[nodiscard]] QFile::open) by
    # removing the blanket -Werror.
    substituteInPlace variables.cmake --replace-fail 'set(CMAKE_CXX_FLAGS "''${CMAKE_CXX_FLAGS} -Werror")' ""

    # On Linux, QLC+'s build system hardcodes all of its installation
    # directories (binaries, libraries, data files, ...) to be relative to
    # "/usr", following the same "install root" convention used by its
    # Debian packaging (see INSTALL_ROOT below). Drop that hardcoded "/usr"
    # prefix so everything installs directly under $out in the conventional
    # FHS-style layout instead of $out/usr.
    substituteInPlace variables.cmake --replace-fail 'set(INSTALLROOT "/usr")' 'set(INSTALLROOT "")'
  '';

  cmakeFlags = [
    # QLC+ 5's QML-based UI, as opposed to the legacy Qt Widgets UI.
    (lib.cmakeBool "qmlui" true)
    # See the INSTALLROOT patch in postPatch above: this is prepended to it
    # (and to a few paths that don't use INSTALLROOT, like the udev rules
    # directory) to form the actual installation prefix.
    (lib.cmakeFeature "INSTALL_ROOT" (placeholder "out"))
    # nixpkgs' cmake setup-hook forces CMAKE_INSTALL_LIBDIR to the absolute
    # path "$out/lib". QLC+ then prepends INSTALLROOT (i.e. $out again, see
    # above) to it, resulting in a doubled-up, nested install path. Reset it
    # back to a plain relative directory so it composes correctly with
    # INSTALLROOT instead.
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  enableParallelBuilding = true;

  doInstallCheck = true;

  postInstall = ''
    ln -sf $out/lib/*/libqlcplus* $out/lib
  '';

  meta = {
    description = "Free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = [ ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    homepage = "https://www.qlcplus.org/";
  };
}
