{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  SDL2,
  libGL,
  libpng,
  libjpeg,
  SDL2_ttf,
  libvorbis,
  gettext,
  physfs,
}:

stdenv.mkDerivation rec {
  pname = "neverball";
  version = "1.6.0";
  src = fetchurl {
    url = "https://neverball.org/neverball-${version}.tar.gz";
    sha256 = "184gm36c6p6vaa6gwrfzmfh86klhnb03pl40ahsjsvprlk667zkk";
  };
  patches = [
    # Pull upstream fix for -fno-common toolchains
    #   https://github.com/Neverball/neverball/pull/198
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/Neverball/neverball/commit/a42492b8db06934c7a794630db92e3ff6ebaadaa.patch";
      sha256 = "0sqyxfwpl4xxra8iz87j5rxzwani16xra2xl4l5z61shvq30308h";
    })
  ];

  buildInputs = [
    libpng
    SDL2
    libGL
    libjpeg
    SDL2_ttf
    libvorbis
    gettext
    physfs
  ];

  dontPatchELF = true;

  postPatch = ''
    sed -i -e 's@\./data@'$out/share/neverball/data@ share/base_config.h Makefile
    sed -i -e 's@\./locale@'$out/share/neverball/locale@ share/base_config.h Makefile
    sed -i -e 's@-lvorbisfile@-lvorbisfile -lX11 -lgcc_s@' Makefile
  '';

  # The map generation code requires a writable HOME
  preConfigure = "export HOME=$TMPDIR";

  installPhase = ''
    mkdir -p $out/bin $out/share/neverball
    cp -R data locale $out/share/neverball
    cp neverball $out/bin
    cp neverputt $out/bin
    cp mapc $out/bin
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://neverball.org/";
    description = "Tilt the floor to roll a ball";
    license = "GPL";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
