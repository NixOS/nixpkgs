{
  lib,
  stdenv,
  fetchgit,
  flex,
  bison,
  fig2dev,
  imagemagick,
  netpbm,
  gtk2,
  pkg-config,
}:

with lib;
stdenv.mkDerivation {
  pname = "fped";
  version = "unstable-2017-05-11";

  src = fetchgit {
    url = "git://projects.qi-hardware.com/fped.git";
    rev = "fa98e58157b6f68396d302c32421e882ac87f45b";
    sha256 = "0xv364a00zwxhd9kg1z9sch5y0cxnrhk546asspyb9bh58sdzfy7";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: postscript.o:postscript.h:29: multiple definition of
  #     `postscript_params'; fped.o:postscript.h:29: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  # This uses '/bin/bash', '/usr/local' and 'lex' by default
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LEX=flex"
    "RGBDEF=${netpbm.out}/share/netpbm/misc/rgb.txt"
  ];

  nativeBuildInputs = [
    flex
    bison
    pkg-config
    imagemagick
    fig2dev
    netpbm
  ];

  buildInputs = [
    gtk2
  ];

  meta = {
    description = "An editor that allows the interactive creation of footprints electronic components";
    mainProgram = "fped";
    homepage = "http://projects.qi-hardware.com/index.php/p/fped/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.linux;
  };
}
