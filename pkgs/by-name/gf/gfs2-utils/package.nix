{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  bison,
  flex,
  pkg-config,
  bzip2,
  check,
  ncurses,
  util-linux,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gfs2-utils";
  version = "3.5.1";

  src = fetchurl {
    url = "https://pagure.io/gfs2-utils/archive/${version}/gfs2-utils-${version}.tar.gz";
    hash = "sha256-ZWzNfYuhIxGmSAe454vRjAKp9Lq7EBBSY36P7qVgZnw=";
  };

  outputs = [
    "bin"
    "doc"
    "out"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];
  buildInputs = [
    bzip2
    ncurses
    util-linux
    zlib
  ];

  nativeCheckInputs = [ check ];
  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://pagure.io/gfs2-utils";
    description = "Tools for creating, checking and working with gfs2 filesystems";
    maintainers = with lib.maintainers; [ qyliss ];
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    platforms = lib.platforms.linux;
  };
}
