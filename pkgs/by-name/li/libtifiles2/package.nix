{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  autoreconfHook,
  glib,
  libarchive,
  libticonv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtifiles2";
  version = "1.1.7";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/libtifiles2-${finalAttrs.version}.tar.bz2";
    sha256 = "10n9mhlabmaw3ha5ckllxfy6fygs2pmlmj5v6w5v62bvx54kpils";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    libarchive
    libticonv
  ];

  meta = {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
