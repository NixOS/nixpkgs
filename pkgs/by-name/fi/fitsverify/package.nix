{
  lib,
  stdenv,
  fetchurl,
  cfitsio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fitsverify";
  version = "4.22";

  src = fetchurl {
    url = "https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/fitsverify-${finalAttrs.version}.tar.gz";
    hash = "sha256-bEXoA6fg7by30TkYYVuuY2HSszPCkrhJxQnsm+vbGLQ=";
  };

  buildInputs = [
    cfitsio
  ];

  # See build instructions in the README file in src.
  buildPhase = ''
    $CC -o fitsverify ftverify.c fvrf_data.c fvrf_file.c fvrf_head.c \
       fvrf_key.c fvrf_misc.c -DSTANDALONE \
       $NIX_CFLAGS_COMPILE \
       -lcfitsio
  '';

  installPhase = ''
    install -D fitsverify $out/bin/fitsverify
  '';

  meta = with lib; {
    description = "FITS File Format-Verification Tool";
    mainProgram = "fitsverify";
    longDescription = ''
      Fitsverify is a computer program that rigorously checks whether a FITS
      (Flexible Image Transport System) data file conforms to all the
      requirements defined in Version 3.0 of the FITS Standard document.
    '';
    homepage = "https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/";
    license = licenses.mit;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ panicgh ];
  };
})
