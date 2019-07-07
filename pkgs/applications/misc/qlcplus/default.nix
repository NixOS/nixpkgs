{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, udev
, qtmultimedia, qtscript, alsaLib, ola, libftdi1, libusb
, libsndfile, libmad
}:

mkDerivation rec {
  name = "qlcplus-${version}";
  version = "4.12.1";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "1kz2zbz7blnm91dysn949bjsy4xqxg658k47p3gbl0pjl58c44hp";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [
    udev qtmultimedia qtscript alsaLib ola libftdi1 libusb libsndfile libmad
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

  meta = with stdenv.lib; {
    description = "A free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc.";
    maintainers = [ maintainers.globin ];
    license = licenses.asl20;
    platforms = platforms.all;
    homepage = "http://www.qlcplus.org/";
  };
}
