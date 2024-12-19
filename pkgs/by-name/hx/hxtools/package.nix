{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  zstd,
  libHX,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hxtools";
  version = "20231224";

  src = fetchurl {
    url = "https://inai.de/files/hxtools/hxtools-${finalAttrs.version}.tar.zst";
    hash = "sha256-TyT9bsp9qqGKQsSyWCfd2lH8ULjqJ5puMTw2TgWHV5c=";
  };

  nativeBuildInputs = [
    pkg-config
    zstd
  ];

  buildInputs = [
    libHX
  ];

  strictDeps = true;

  meta = {
    homepage = "https://inai.de/projects/hxtools/";
    description = "Collection of small tools over the years by j.eng";
    # Taken from https://codeberg.org/jengelh/hxtools/src/branch/master/LICENSES.txt
    license = with lib.licenses; [
      mit
      bsd2Patent
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ meator ];
    platforms = lib.platforms.all;
  };
})
