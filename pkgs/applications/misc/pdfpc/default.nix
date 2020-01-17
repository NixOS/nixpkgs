{ stdenv, fetchFromGitHub, cmake, pkgconfig, vala, gtk3, libgee, fetchpatch
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, librsvg, pcre, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "pdfpc";
  version = "4.3.4";

  src = fetchFromGitHub {
    repo = product;
    owner = product;
    rev = "v${version}";
    sha256 = "07aafsm4jzdgpahz83p0ajv40hry7gviyadqi13ahr8xdhhwy2sd";
  };

  nativeBuildInputs = [
    cmake pkgconfig vala
    # For setup hook
    gobject-introspection
    wrapGAppsHook
  ];
  buildInputs = [ gstreamer gst-plugins-base gtk3 libgee poppler
    libpthreadstubs librsvg pcre ];

  cmakeFlags = stdenv.lib.optional stdenv.isDarwin "-DMOVIES=OFF";

  patches = [
    # Fix build vala 0.46
    (fetchpatch {
      url = "https://github.com/pdfpc/pdfpc/commit/bbc16b97ecbdcdd22c2dc827a5c0e8b569073312.patch";
      sha256 = "0wi1rqcvg65cxnxvmvavcvghqyksnpijq1p91m57jaby3hb0pdcy";
    })
  ];

  meta = with stdenv.lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = https://pdfpc.github.io/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };

}
