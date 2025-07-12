{
  lib,
  stdenv,
  autoreconfHook,
  fetchurl,
  fetchpatch,
  glib,
  gobject-introspection,
  gtk-doc,
  libtool,
  libxml2,
  libxslt,
  openssl,
  pkg-config,
  python3,
  xmlsec,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "lasso";
  version = "2.8.2";

  src = fetchurl {
    url = "https://dev.entrouvert.org/lasso/lasso-${version}.tar.gz";
    hash = "sha256-ahgxv9v49CTHUIq6R7BF1RNB7A/ekSLziwuGsJbvUz4=";
  };

  patches = [
    # Fix build with xmlsec 1.3.0
    (fetchpatch {
      url = "https://git.entrouvert.org/entrouvert/lasso/commit/ffaddeb015a61db3e52c391de00430107a23e2f1.patch";
      hash = "sha256-D2npxpIuR/KrNYiKO3KXCvHEb/XVXUKIP0HQUd+w56k=";
    })
    # Fix GCC 14 implicit declaration of function
    # backported patch of https://git.entrouvert.org/entrouvert/lasso/commit/9767cdf7645a146bcc596a705ce32b855855a590
    ./fix-gcc14-implicit-function-declaration.diff
    # Fix GCC 14 incompatible pointer
    # backported patch of https://git.entrouvert.org/entrouvert/lasso/commit/cbe2c45455d93ed793dc4be59e3d2d26f1bd1111
    ./fix-gcc14-incompatible-pointer.diff
    # Fix GCC 14 int-conversion (xmlsec)
    (fetchpatch {
      url = "https://git.entrouvert.org/entrouvert/lasso/commit/66c9f50f1f6b00d621a9a0ca2f924875f94d14ae.patch";
      hash = "sha256-UkWxznKx2xAbjY29+NQ+cjIDhWLuyoWsmBTSiLUxWgU=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk-doc
    libtool
    libxml2
    libxslt
    openssl
    python3.pkgs.six
    xmlsec
    zlib
  ];

  configurePhase = ''
    ./configure --with-pkg-config=$PKG_CONFIG_PATH \
                --disable-perl \
                --prefix=$out
  '';

  meta = {
    homepage = "https://lasso.entrouvert.org/";
    description = "Liberty Alliance Single Sign-On library";
    changelog = "https://git.entrouvert.org/entrouvert/lasso/raw/tag/v${version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
  };
}
