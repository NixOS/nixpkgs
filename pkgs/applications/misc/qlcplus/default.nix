{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, udev
, qtmultimedia, qtscript, alsaLib, ola, libftdi, libusb
, libsndfile, libmad
}:

mkDerivation rec {
  name = "qlcplus-${version}";
  version = "4.11.0";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "0a45ww341yjx9k54j5s8b5wj83rgbwxkdvgy0v5jbbdf9m78ifrg";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [
    udev qtmultimedia qtscript alsaLib ola libftdi libusb libsndfile libmad
  ];

  qmakeFlags = [ "INSTALLROOT=$(out)" ];

  postPatch = ''
    patchShebangs .
    sed -i -e '/unix:!macx:INSTALLROOT += \/usr/d' \
            -e "s@\$\$LIBSDIR/qt4/plugins@''${qtPluginPrefix}@" \
            -e "s@/etc/udev/rules.d@''${out}/lib/udev@" \
      variables.pri
  '';

  meta = with stdenv.lib; {
    description = "A free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc.";
    maintainers = [ maintainers.globin ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
