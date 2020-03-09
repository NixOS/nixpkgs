{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, udev
, qtmultimedia, qtscript, alsaLib, ola, libftdi1, libusb
, libsndfile, libmad
}:

mkDerivation rec {
  pname = "qlcplus";
  version = "4.12.2";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "1j0jhgql78p5ghcaz36l1k55447s5qiv396a448qic7xqpym2vl3";
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
    homepage = "https://www.qlcplus.org/";
  };
}
