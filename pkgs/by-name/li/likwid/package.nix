{
  lib,
  stdenv,
  fetchurl,
  perl,
  substituteAll,
  coreutils,
  gnugrep,
}:

stdenv.mkDerivation rec {
  pname = "likwid";
  version = "5.3.0";

  src = fetchurl {
    url = "https://ftp.fau.de/pub/likwid/likwid-${version}.tar.gz";
    hash = "sha256-wpDlVMQlMSSsKriwVuFO5NI5ZrjJ+/oQuoH3WuVDzk4=";
  };

  nativeBuildInputs = [ perl ];

  hardeningDisable = [ "format" ];

  patches = [
    ./nosetuid.patch
    (substituteAll {
      src = ./cat-grep-sort-wc.patch;
      coreutils = "${coreutils}/bin/";
      gnugrep = "${gnugrep}/bin/";
    })
  ];

  postPatch = "patchShebangs bench/ perl/";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://hpc.fau.de/research/tools/likwid/";
    changelog = "https://github.com/RRZE-HPC/likwid/releases/tag/v${version}";
    description = "Performance monitoring and benchmarking suite";
    license = licenses.gpl3Only;
    # Might work on ARM by appropriately setting COMPILER in config.mk
    platforms = intersectLists platforms.linux platforms.x86;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "likwid-perfctr";
  };
}
