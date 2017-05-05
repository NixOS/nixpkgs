{ fetchurl, stdenv, lzip, texinfo }:

stdenv.mkDerivation rec {
  name = "ocrad-0.26";

  src = fetchurl {
    url = "mirror://gnu/ocrad/${name}.tar.lz";
    sha256 = "0g4fq7maybdnd1471kd05a3f5sb7spa3d26k706rk85sd5wd70y3";
  };

  buildInputs = [ lzip texinfo ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Optical character recognition (OCR) program & library";
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

    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.gnu;  # arbitrary choice
  };
}
