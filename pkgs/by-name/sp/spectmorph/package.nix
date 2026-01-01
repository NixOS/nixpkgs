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

<<<<<<< HEAD
  meta = {
    description = "Allows to analyze samples of musical instruments, and to combine them (morphing) to construct hybrid sounds";
    homepage = "https://spectmorph.org";
    license = lib.licenses.gpl3;
=======
  meta = with lib; {
    description = "Allows to analyze samples of musical instruments, and to combine them (morphing) to construct hybrid sounds";
    homepage = "https://spectmorph.org";
    license = licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
<<<<<<< HEAD
    maintainers = [ lib.maintainers.magnetophon ];
=======
    maintainers = [ maintainers.magnetophon ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
