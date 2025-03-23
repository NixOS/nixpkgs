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
  alsa-lib,
  ola,
  libftdi1,
  libusb-compat-0_1,
  libsndfile,
  libmad,
}:

mkDerivation rec {
  pname = "qlcplus";
  version = "4.13.1";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "sha256-AKmPxHOlMtea3q0NDULp3XfJ0JnYeF/iFUJw0dDOiio=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
  ];
  buildInputs = [
    udev
    qtmultimedia
    qtscript
    qtserialport
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

  postInstall = ''
    ln -sf $out/lib/*/libqlcplus* $out/lib
  '';

  meta = with lib; {
    description = "Free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = [ ];
    license = licenses.asl20;
    platforms = platforms.all;
    homepage = "https://www.qlcplus.org/";
  };
}
