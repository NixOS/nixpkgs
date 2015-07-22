{ stdenv, fetchurl, cmake, makeWrapper, pkgconfig, vala, gtk3, libgee, poppler
, libpthreadstubs, gstreamer, gst-plugins-base, librsvg }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/pdfpc/pdfpc/releases/download/v${version}/${product}-v${version}.tar.gz";
    sha256 = "0qksci11pgvabfdnynkpj2av0iww8m9m41a0vwsqgvg3yiacb4f0";
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
