{ lib, stdenv, fetchFromGitHub, poppler, pkg-config, gdk-pixbuf, SDL, gtk2 }:

stdenv.mkDerivation {
  pname = "green-pdfviewer";
  version = "nightly-2014-04-22";

  src = fetchFromGitHub {
    owner = "schandinat";
    repo = "green";
    rev = "0b516aec17915d9742d8e505d2ed383a3bdcea61";
    sha256 = "0d0lv33flhgsxhc77kfp2avdz5gvml04r8l1j95yjz2rr096lzlj";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ poppler gdk-pixbuf SDL gtk2 ];

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

  meta = with lib; {
    homepage = "https://github.com/schandinat/green/";
    description = "Viewer for PDF files, uses SDL and libpoppler";

    platforms = platforms.unix;
    license  = licenses.gpl3;
    maintainers = [ maintainers.vrthra ];
    mainProgram = "green";
  };
}
