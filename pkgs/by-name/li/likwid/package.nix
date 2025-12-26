{
  lib,
  stdenv,
  fetchurl,
  perl,
  replaceVars,
  coreutils,
  gnugrep,
}:

stdenv.mkDerivation rec {
  pname = "likwid";
  version = "5.5.0";

  src = fetchurl {
    url = "https://ftp.fau.de/pub/likwid/likwid-${version}.tar.gz";
    hash = "sha256-aIkk/gE0BwfCwxi3+GfuYPt1G5X0lUvILTofdqOhUFY=";
  };

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" ];

  patches = [
    ./nosetuid.patch
    (replaceVars ./cat-grep-sort-wc.patch {
      coreutils = "${coreutils}/bin/";
      gnugrep = "${gnugrep}/bin/";
    })
  ];

  postPatch = "patchShebangs bench/ perl/";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://hpc.fau.de/research/tools/likwid/";
    changelog = "https://github.com/RRZE-HPC/likwid/releases/tag/v${version}";
    description = "Performance monitoring and benchmarking suite";
    license = lib.licenses.gpl3Only;
    # Might work on ARM by appropriately setting COMPILER in config.mk
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "likwid-perfctr";
  };
}
