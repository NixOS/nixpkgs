{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig, vala, gtk3, libgee
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, librsvg }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.0.3";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    sha256 = "1fcwxvik3nnn0g37xvb30vxaxwrd881fw07fyfb9c6ami9bnva3p";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ gstreamer gst-plugins-base vala gtk3 libgee poppler
    libpthreadstubs makeWrapper librsvg ];

  postInstall = ''
    wrapProgram $out/bin/pdfpc \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = https://pdfpc.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };

}
