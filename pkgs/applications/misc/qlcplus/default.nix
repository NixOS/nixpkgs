{ lib, mkDerivation, fetchFromGitHub, qmake, pkg-config, udev
, qtmultimedia, qtscript, alsaLib, ola, libftdi1, libusb-compat-0_1
, libsndfile, libmad
}:

mkDerivation rec {
  pname = "qlcplus";
  version = "4.12.3";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "PB1Y8N1TrJMcS7A2e1nKjsUlAxOYjdJqBhbyuDCAbGs=";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    udev qtmultimedia qtscript alsaLib ola libftdi1 libusb-compat-0_1 libsndfile libmad
  ];

  qmakeFlags = [ "INSTALLROOT=$(out)" ];

  postPatch = ''
    patchShebangs .
    sed -i -e '/unix:!macx:INSTALLROOT += \/usr/d' \
            -e "s@\$\$LIBSDIR/qt4/plugins@''${qtPluginPrefix}@" \
            -e "s@/etc/udev/rules.d@''${out}/lib/udev/rules.d@" \
      variables.pri
  '';

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf $out/lib/*/libqlcplus* $out/lib
  '';

  meta = with lib; {
    description = "A free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = [ maintainers.globin ];
    license = licenses.asl20;
    platforms = platforms.all;
    homepage = "https://www.qlcplus.org/";
  };
}
