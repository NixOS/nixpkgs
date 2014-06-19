{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "ocrad-0.21";

  src = fetchurl {
    url = "mirror://gnu/ocrad/${name}.tar.gz";
    sha256 = "1k58ha70r0cqahssx67hfgyzia9ymf691yay06n7nrkbklii3isf";
  };

  doCheck = true;

  meta = {
    description = "GNU Ocrad, optical character recognition (OCR) program & library";

    longDescription =
      '' GNU Ocrad is an OCR (Optical Character Recognition) program based on
         a feature extraction method.  It reads images in pbm (bitmap), pgm
         (greyscale) or ppm (color) formats and produces text in byte (8-bit)
         or UTF-8 formats.

         Also includes a layout analyser able to separate the columns or
         blocks of text normally found on printed pages.

         Ocrad can be used as a stand-alone console application, or as a
         backend to other programs.
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
