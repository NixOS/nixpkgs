{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig, vala_0_26, gtk3, libgee
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, librsvg }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.0.2";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    sha256 = "0151i9msagcqcfaddgd1vkmman0qgqy6s3714sqas568r4r9ngdk";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ gstreamer gst-plugins-base vala_0_26 gtk3 libgee poppler
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
