{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  allegro4,
}:

let
  allegro = allegro4;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "garden-of-coloured-lights";
  version = "1.0.9";

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ allegro ];

  prePatch = ''
    noInline='s/inline //'
    sed -e "$noInline" -i src/stuff.c
    sed -e "$noInline" -i src/stuff.h
  '';

  src = fetchurl {
    url = "mirror://sourceforge/garden/${finalAttrs.version}/garden-${finalAttrs.version}.tar.gz";
    hash = "sha256-2vhzLCKaTMBPRgUUv/G6BRcfqtqeGVdccqUKkU8jUuM=";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:src/main.c:58: multiple definition of
  #     `eclass'; eclass.o:src/eclass.c:21: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    description = "Old-school vertical shoot-em-up / bullet hell";
    mainProgram = "garden";
    homepage = "https://sourceforge.net/projects/garden/";
    maintainers = [ ];
    license = lib.licenses.gpl3;
  };
})
