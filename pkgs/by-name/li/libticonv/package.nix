{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libticonv";
  version = "1.1.5";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/libticonv-${finalAttrs.version}.tar.bz2";
    sha256 = "0y080v12bm81wgjm6fnw7q0yg7scphm8hhrls9njcszj7fkscv9i";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  configureFlags = [
    "--enable-iconv"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "LDFLAGS=-liconv";

  meta = {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
