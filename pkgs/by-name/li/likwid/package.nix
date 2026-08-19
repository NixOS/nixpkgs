{
  lib,
  stdenv,
  fetchurl,
  perl,
  replaceVars,
  coreutils,
  gnugrep,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "likwid";
  version = "5.5.1";

  src = fetchurl {
    url = "https://ftp.fau.de/pub/likwid/likwid-${finalAttrs.version}.tar.gz";
    hash = "sha256-JceDDmOyA5b8/DsWrnnDm0IgqG03bOt81pSbX/mR23g=";
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
    changelog = "https://github.com/RRZE-HPC/likwid/releases/tag/v${finalAttrs.version}";
    description = "Performance monitoring and benchmarking suite";
    license = lib.licenses.gpl3Only;
    # Might work on ARM by appropriately setting COMPILER in config.mk
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "likwid-perfctr";
  };
})
