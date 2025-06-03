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

stdenv.mkDerivation rec {
  pname = "libtifiles2";
  version = "1.1.7";
  src = fetchurl {
    url = "mirror://sourceforge/tilp/${pname}-${version}.tar.bz2";
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

  meta = with lib; {
    changelog = "http://lpg.ticalc.org/prj_tilp/news.html";
    description = "This library is part of the TiLP framework";
    homepage = "http://lpg.ticalc.org/prj_tilp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      siraben
      clevor
    ];
    platforms = with platforms; linux ++ darwin;
  };
}
