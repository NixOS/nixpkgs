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
  darwin,
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
  version = "4.5-01";
  pname = "imager";

  src = fetchurl {
    # The recommended download link is on Nextcloud instance that
    # requires to accept some general terms of use. Use a mirror at
    # univ-grenoble-alpes.fr instead.
    url = "https://cloud.univ-grenoble-alpes.fr/s/J6yEqA6yZ8tX9da/download?path=%2F&files=imager-may25.tar.gz";
    hash = "sha256-E3JjdVGEQ0I/ogYj0G1OZxfQ3hA+sRgA4LAfHK52Sec=";
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
    # Fix the numpy header detection with numpy > 2.0.0
    # Patch submitted upstream, it will be included in the next release.
    ./numpy-header.patch
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unused-command-line-argument";

  # Workaround for https://github.com/NixOS/nixpkgs/issues/304528
  env.GAG_CPP = if stdenv.hostPlatform.isDarwin then "${gfortran.outPath}/bin/cpp" else "cpp";

  postPatch = ''
    substituteInPlace utilities/main/gag-makedepend.pl --replace-fail '/usr/bin/perl' ${lib.getExe perl}
  '';

  configurePhase = ''
    source admin/gildas-env.sh -c gfortran -o openmp
    echo "gag_doc:        $out/share/doc/" >> kernel/etc/gag.dico.lcl
  '';

  postInstall = ''
    cp -a ../gildas-exe/* $out
    mv $out/$GAG_EXEC_SYSTEM $out/libexec
    makeWrapper $out/libexec/bin/imager $out/bin/imager \
       --set GAG_ROOT_DIR $out \
       --set GAG_PATH $out/etc \
       --set GAG_EXEC_SYSTEM libexec \
       --set GAG_GAG \$HOME/.gag \
       --set PYTHONHOME ${python3Env} \
       --prefix PYTHONPATH : $out/libexec/python \
       --set LD_LIBRARY_PATH $out/libexec/lib/
  '';

  meta = {
    description = "Interferometric imaging package";
    longDescription = ''
      IMAGER is an interferometric imaging package in the GILDAS software,
      tailored for usage simplicity and efficiency for multi-spectral data sets.

      IMAGER was developed and optimized to handle large data files.
      Therefore, IMAGER works mostly on internal buffers and avoids as much as possible
      saving data to intermediate files.
      File saving is done ultimately once the data analysis process is complete,
      which offers an optimum use of the disk bandwidth.
    '';
    homepage = "https://imager.oasu.u-bordeaux.fr";
    license = lib.licenses.free;
    maintainers = [ lib.maintainers.smaret ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

})
