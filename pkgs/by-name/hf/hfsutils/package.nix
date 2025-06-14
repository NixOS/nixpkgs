{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "hfsutils";
  version = "3.2.6-unstable-2018-01-17";

  src = fetchFromGitHub {
    owner = "JotaRandom";
    repo = "hfsutils";
    rev = "263327c7cd0e788282c949fbcb03791009c9943c";
    hash = "sha256-P4VixeG4rMerXvBXHKcjqF2vbsJRsblYfLeMD5fNW74=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  # fix makefile trying to touch files in .stamp w/o dir created
  preConfigure = ''
    mkdir -p .stamp
  '';

  # ignore implicit strcmp declaration in hpwd.c's function hpwd_main
  # patch source to include <string.h>?
  NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  meta = {
    description = "Tools for reading and writing Macintosh HFS volumes";
    homepage = "http://www.mars.org/home/rob/proj/hfs/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
