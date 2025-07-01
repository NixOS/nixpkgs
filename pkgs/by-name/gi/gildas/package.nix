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
  makeWrapper,
}:

let
  python3Env = python3.withPackages (
    ps: with ps; [
      numpy
      setuptools
    ]
  );
in

stdenv.mkDerivation (finalAttrs: {
  srcVersion = "jun25a";
  version = "20250601_a";
  pname = "gildas";

  src = fetchurl {
    # For each new release, the upstream developers of Gildas move the
    # source code of the previous release to a different directory
    urls = [
      "http://www.iram.fr/~gildas/dist/gildas-src-${finalAttrs.srcVersion}.tar.xz"
      "http://www.iram.fr/~gildas/dist/archive/gildas/gildas-src-${finalAttrs.srcVersion}.tar.xz"
    ];
    hash = "sha256-DhUGaG96bsZ1NGfDQEujtiM0AUwZBMD42uRpRWI5DX0=";
  };

  nativeBuildInputs = [
    pkg-config
    groff
    perl
    getopt
    gfortran
    which
    makeWrapper
  ];

  buildInputs = [
    gtk2-x11
    cfitsio
    python3Env
    ncurses
  ];

  patches = [
    # Use Clang as the default compiler on Darwin.
    ./clang.patch
    # Replace hardcoded cpp with GAG_CPP (see below).
    ./cpp-darwin.patch
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument";

  # Workaround for https://github.com/NixOS/nixpkgs/issues/304528
  env.GAG_CPP = if stdenv.hostPlatform.isDarwin then "${gfortran.outPath}/bin/cpp" else "cpp";

  configurePhase = ''
    substituteInPlace utilities/main/gag-makedepend.pl --replace-fail '/usr/bin/perl' ${lib.getExe perl}
    source admin/gildas-env.sh -c gfortran -o openmp
    echo "gag_doc:        $out/share/doc/" >> kernel/etc/gag.dico.lcl
  '';

  userExec = "astro class greg mapping sic";

  postInstall = ''
    cp -a ../gildas-exe-${finalAttrs.srcVersion}/* $out
    mv $out/$GAG_EXEC_SYSTEM $out/libexec
    for i in ${finalAttrs.userExec} ; do
       makeWrapper $out/libexec/bin/$i $out/bin/$i \
          --set GAG_ROOT_DIR $out \
          --set GAG_PATH $out/etc \
          --set GAG_EXEC_SYSTEM libexec \
          --set GAG_GAG \$HOME/.gag \
          --set PYTHONHOME ${python3Env} \
          --prefix PYTHONPATH : $out/libexec/python \
          --set LD_LIBRARY_PATH $out/libexec/lib/
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

})
