{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qmake,
  pkg-config,
  udev,
  qtmultimedia,
  qtscript,
  qtserialport,
  qtwebsockets,
  alsa-lib,
  ola,
  libftdi1,
  libusb-compat-0_1,
  libsndfile,
  libmad,
  udevCheckHook,
}:

mkDerivation rec {
  pname = "qlcplus";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    hash = "sha256-UVGSmmtzNqeD+mU2nROoFqdHx79zgMPem4NHWerp3GQ=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    udevCheckHook
  ];
  buildInputs = [
    udev
    qtmultimedia
    qtscript
    qtserialport
    qtwebsockets
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
