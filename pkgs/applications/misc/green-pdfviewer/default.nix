{ stdenv, fetchFromGitHub, poppler, pkgconfig, gdk_pixbuf, SDL, gtk }:

stdenv.mkDerivation rec {
  name = "green-pdfviewer-${version}";
  version = "nightly-2014-04-22";

  src = fetchFromGitHub {
    owner = "schandinat";
    repo = "green";
    rev = "0b516aec17915d9742d8e505d2ed383a3bdcea61";
    sha256 = "0d0lv33flhgsxhc77kfp2avdz5gvml04r8l1j95yjz2rr096lzlj";
  };

  buildInputs = [ poppler pkgconfig gdk_pixbuf SDL gtk ];

  patches = [
    ./gdk-libs.patch
  ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man1
    make install PREFIX=$out MANDIR=$out/share
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/schandinat/green/;
    description = "Viewer for PDF files, uses SDL and libpoppler";

    platforms = platforms.unix;
    license  = licenses.gpl3;
    maintainers = [ maintainers.vrthra ];
  };
}
