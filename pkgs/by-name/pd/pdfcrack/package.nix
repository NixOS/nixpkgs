{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "pdfcrack";
  version = "0.20";

  src = fetchurl {
    url = "mirror://sourceforge/pdfcrack/pdfcrack/pdfcrack-${version}.tar.gz";
    hash = "sha256-e4spsY/NXLmErrZA7gbt8J/t5HCbWcMv7k8thoYN5bQ=";
  };

  installPhase = ''
    install -Dt $out/bin pdfcrack
  '';

  meta = {
    homepage = "https://pdfcrack.sourceforge.net/";
    description = "Small command line driven tool for recovering passwords and content from PDF files";
    mainProgram = "pdfcrack";
    license = with lib.licenses; [ gpl2Plus ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ qoelet ];
  };
}
