{ lib, mkDerivation, fetchFromGitHub, fetchpatch, qmake, pkg-config, udev
, qtmultimedia, qtscript, alsa-lib, ola, libftdi1, libusb-compat-0_1
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

  patches = [
    (fetchpatch {
      name = "qt5.15-deprecation-fixes.patch";
      url = "https://github.com/mcallegari/qlcplus/commit/e4ce4b0226715876e8e9e3b23785d43689b2bb64.patch";
      sha256 = "1zhrg6ava1nyc97xcx75r02zzkxmar0973w4jwkm5ch3iqa8bqnh";
    })
  ];

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    udev qtmultimedia qtscript alsa-lib ola libftdi1 libusb-compat-0_1 libsndfile libmad
  ];

  qmakeFlags = [ "INSTALLROOT=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    patchShebangs .
    sed -i -e '/unix:!macx:INSTALLROOT += \/usr/d' \
            -e "s@\$\$LIBSDIR/qt4/plugins@''${qtPluginPrefix}@" \
            -e "s@/etc/udev/rules.d@''${out}/lib/udev/rules.d@" \
      variables.pri
  '';

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
