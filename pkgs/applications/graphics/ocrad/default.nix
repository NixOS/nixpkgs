{
  fetchurl,
  lib,
  stdenv,
  lzip,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "ocrad";
  version = "0.27";

  src = fetchurl {
    url = "mirror://gnu/ocrad/${pname}-${version}.tar.lz";
    sha256 = "0divffvcaim89g4pvqs8kslbcxi475bcl3b4ynphf284k9zfdgx9";
  };

  nativeBuildInputs = [
    lzip # unpack
  ];
  buildInputs = [ texinfo ];

  doCheck = true;

  meta = with lib; {
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

    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
    mainProgram = "ocrad";
  };
}
