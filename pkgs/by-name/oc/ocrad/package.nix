{
  lib,
  stdenv,
  fetchurl,
  lzip,
  texinfo,
  libpng,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocrad";
  version = "0.29";

  src = fetchurl {
    url = "mirror://gnu/ocrad/ocrad-${finalAttrs.version}.tar.lz";
    hash = "sha256-ESAMxrC3uhaISnLcy1jvaU96omzSsgQeVVWA8GTS2ek=";
  };

  nativeBuildInputs = [
    lzip # unpack
  ];

  buildInputs = [
    texinfo
    libpng
  ];

  doCheck = true;

  meta = {
    description = "Optical character recognition (OCR) program & library";
    longDescription = ''
      GNU Ocrad is an OCR (Optical Character Recognition) program based on
      a feature extraction method.  It reads images in pbm (bitmap), pgm
      (greyscale) or ppm (color) formats and produces text in byte (8-bit)
      or UTF-8 formats.

      Also includes a layout analyser able to separate the columns or
      blocks of text normally found on printed pages.

      Ocrad can be used as a stand-alone console application, or as a
      backend to other programs.
    '';

    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.unix;
    mainProgram = "ocrad";
  };
})
