{ stdenv, fetchFromGitHub, cmake, makeWrapper, pkgconfig, vala, gtk3, libgee
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, librsvg, pcre }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.0.7";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    sha256 = "00qfmmk8h762p53z46g976z7j4fbxyi16w5axzsv1ymvdq95ds8c";
  };

  nativeBuildInputs = [ cmake pkgconfig vala ];
  buildInputs = [ gstreamer gst-plugins-base gtk3 libgee poppler
    libpthreadstubs makeWrapper librsvg pcre ];

  cmakeFlags = stdenv.lib.optionalString stdenv.isDarwin "-DMOVIES=OFF";

  postInstall = ''
    wrapProgram $out/bin/pdfpc \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
  '';

  meta = with stdenv.lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = https://pdfpc.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };

}
