{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  djvulibre,
  ghostscript,
  which,
}:

stdenv.mkDerivation rec {
  version = "0.9.2";
  pname = "djvu2pdf";

  src = fetchurl {
    url = "http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-${version}.tar.gz";
    sha256 = "0v2ax30m7j1yi4m02nzn9rc4sn4vzqh5vywdh96r64j4pwvn5s5g";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -p djvu2pdf $out/bin
    wrapProgram $out/bin/djvu2pdf --prefix PATH : ${
      lib.makeBinPath [
        ghostscript
        djvulibre
        which
      ]
    }

    mkdir -p $out/man/man1
    cp -p djvu2pdf.1.gz $out/man/man1
  '';

  meta = {
    description = "Convert DjVu files to PDF files";
    homepage = "https://0x2a.at/site/projects/djvu2pdf/";
    license = lib.licenses.gpl1Only;
    platforms = lib.platforms.all;
    mainProgram = "djvu2pdf";
  };
}
