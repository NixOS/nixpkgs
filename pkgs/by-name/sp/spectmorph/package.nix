{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libjack2,
  lv2,
  glib,
  qt5,
  libao,
  cairo,
  libsndfile,
  fftwFloat,
}:

stdenv.mkDerivation rec {
  pname = "spectmorph";
  version = "0.6.1";
  src = fetchurl {
    url = "https://github.com/swesterfeld/spectmorph/releases/download/${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-H/PaczAkjxeu2Q6S/jazZ0PU9oCmhBzsLgbGLusxXm8=";
  };

  buildInputs = [
    libjack2
    lv2
    glib
    qt5.qtbase
    libao
    cairo
    libsndfile
    fftwFloat
  ];

  nativeBuildInputs = [ pkg-config ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Allows to analyze samples of musical instruments, and to combine them (morphing) to construct hybrid sounds";
    homepage = "https://spectmorph.org";
    license = licenses.gpl3;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ maintainers.magnetophon ];
  };
}
