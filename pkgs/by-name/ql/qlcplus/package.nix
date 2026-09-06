{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  udevCheckHook,
  udev,
  libsForQt5,
  alsa-lib,
  ola,
  libftdi1,
  libusb-compat-0_1,
  libsndfile,
  libmad,
}:

stdenv.mkDerivation rec {
  pname = "qlcplus";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    hash = "sha256-gEwcTIJhY78Ts0lUn4MVciV7sPIBkqlxPMa9I1nTHO0=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    udevCheckHook
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    udev
    libsForQt5.qtmultimedia
    libsForQt5.qtscript
    libsForQt5.qtserialport
    libsForQt5.qtwebsockets
    alsa-lib
    ola
    libftdi1
    libusb-compat-0_1
    libsndfile
    libmad
  ];

  qmakeFlags = [ "INSTALLROOT=$(out)" ];

  postPatch = ''
    patchShebangs .
    sed -i -e '/unix:!macx:INSTALLROOT += \/usr/d' \
            -e "s@\$\$LIBSDIR/qt4/plugins@''${qtPluginPrefix}@" \
            -e "s@/etc/udev/rules.d@''${out}/lib/udev/rules.d@" \
      variables.pri

    # Fix gcc-13 build failure by removing blanket -Werror.
    fgrep Werror variables.pri
    substituteInPlace variables.pri --replace-fail "QMAKE_CXXFLAGS += -Werror" ""
  '';

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
