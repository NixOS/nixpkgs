{
  lib,
  stdenv,
  fetchurl,
  gtk2-x11,
  pkg-config,
  python3,
  gfortran,
  cfitsio,
  getopt,
  perl,
  groff,
  which,
  ncurses,
}:

let
  python3Env = python3.withPackages (
    ps: with ps; [
      numpy
      setuptools
    ]
  );
in

stdenv.mkDerivation rec {
  srcVersion = "oct25a";
  version = "20251001_a";
  pname = "gildas";

  src = fetchurl {
    # For each new release, the upstream developers of Gildas move the
    # source code of the previous release to a different directory
    urls = [
      "http://www.iram.fr/~gildas/dist/gildas-src-${srcVersion}.tar.xz"
      "http://www.iram.fr/~gildas/dist/archive/gildas/gildas-src-${srcVersion}.tar.xz"
    ];
    hash = "sha256-n1IQajRXIHWkaFpLOtctlm4P+2vrxTWdyQiD3caQd3A=";
  };

  nativeBuildInputs = [
    pkg-config
    groff
    perl
    getopt
    gfortran
    which
  ];

  buildInputs = [
    gtk2-x11
    cfitsio
    python3Env
    ncurses
  ];

  patches = [
    ./wrapper.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./clang.patch
    ./cpp-darwin.patch
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument";

  # Workaround for https://github.com/NixOS/nixpkgs/issues/304528
  env.GAG_CPP = lib.optionalString stdenv.hostPlatform.isDarwin "${gfortran.outPath}/bin/cpp";

  configurePhase = ''
    runHook preConfigure

    substituteInPlace admin/wrapper.sh --replace '%%OUT%%' $out
    substituteInPlace admin/wrapper.sh --replace '%%PYTHONHOME%%' ${python3Env}
    substituteInPlace utilities/main/gag-makedepend.pl --replace '/usr/bin/perl' ${perl}/bin/perl
    source admin/gildas-env.sh -c gfortran -o openmp
    echo "gag_doc:        $out/share/doc/" >> kernel/etc/gag.dico.lcl

    runHook postConfigure
  '';

  userExec = "astro class greg mapping sic";

  postInstall = ''
    mkdir -p $out/bin
    cp -a ../gildas-exe-${srcVersion}/* $out
    mv $out/$GAG_EXEC_SYSTEM $out/libexec
    for i in ${userExec} ; do
      cp admin/wrapper.sh $out/bin/$i
      chmod 755 $out/bin/$i
    done
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Radioastronomy data analysis software";
    longDescription = ''
      GILDAS is a collection of state-of-the-art software
      oriented toward (sub-)millimeter radioastronomical
      applications (either single-dish or interferometer).
      It is daily used to reduce all data acquired with the
      IRAM 30M telescope and Plateau de Bure Interferometer
      PDBI (except VLBI observations). GILDAS is easily
      extensible. GILDAS is written in Fortran-90, with a
      few parts in C/C++ (mainly keyboard interaction,
      plotting, widgets).'';
    homepage = "http://www.iram.fr/IRAMFR/GILDAS/gildas.html";
    license = lib.licenses.free;
    maintainers = [
      lib.maintainers.bzizou
      lib.maintainers.smaret
    ];
    platforms = lib.platforms.all;
  };

}
