{
  lib,
  stdenv,
  fetchurl,
  boost,
  fastjet,
  gfortran,
  gsl,
  lhapdf,
  thepeg,
  zlib,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "herwig";
  version = "7.3.0";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/herwig/Herwig-${finalAttrs.version}.tar.bz2";
    hash = "sha256-JiSBnS3/EFupUuobXPEutvSSbUlRd0pBkHaZ4vVnaGw=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gfortran
  ];

  buildInputs = [
    boost
    fastjet
    gsl
    thepeg
    zlib
  ]
  # There is a bug that requires for default PDF's to be present during the build
  ++ (with lhapdf.pdf_sets; [
    CT14lo
    CT14nlo
  ]);

  postPatch = ''
    patchShebangs ./

    # Fix failing "make install" being unable to find HwEvtGenInterface.so
    substituteInPlace src/defaults/decayers.in.in \
      --replace "read EvtGenDecayer.in" ""
  '';

  configureFlags = [
    "--with-thepeg=${thepeg}"
    "--with-boost=${lib.getDev boost}"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Multi-purpose particle physics event generator";
    homepage = "https://herwig.hepforge.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ veprbl ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64; # doesn't compile: ignoring return value of 'FILE* freopen...
  };
})
