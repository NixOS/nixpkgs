{ stdenv, fetchFromGitHub, cmake, pkgconfig, vala, gtk3, libgee, fetchpatch
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, gst-plugins-good, gst-libav, librsvg, pcre, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.4.0";

  src = fetchFromGitHub {
    repo = product;
    owner = product;
    rev = "v${version}";
    sha256 = "0vh2r32akvasdrghkaq7ard24r2qncp34jfiyshi3zxabm9bhfaa";
  };

  nativeBuildInputs = [
    cmake pkgconfig vala
    # For setup hook
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3 libgee poppler
    libpthreadstubs librsvg pcre
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-libav
  ];

  cmakeFlags = stdenv.lib.optional stdenv.isDarwin "-DMOVIES=OFF";

  meta = with stdenv.lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = "https://pdfpc.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };

}
