{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, vala, gtk3, libgee
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, gst-plugins-good, gst-libav, gobject-introspection, wrapGAppsHook
, qrencode, webkitgtk, discount, json-glib, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "pdfpc";
  version = "4.6.0";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    hash = "sha256-5HFmbVsNajMwo+lBe9kJcJyQGe61N6Oy2CI/WJwmSE4=";
  };

  nativeBuildInputs = [
    cmake pkg-config vala
    # For setup hook
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3 libgee poppler
    libpthreadstubs
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-libav
    qrencode
    webkitgtk
    discount
    json-glib
  ];

  patches = [
    # needed for compiling pdfpc 4.6.0 with vala 0.56.7, see
    # https://github.com/pdfpc/pdfpc/issues/686
    # https://github.com/pdfpc/pdfpc/pull/687
    (fetchpatch {
      url = "https://github.com/pdfpc/pdfpc/commit/d38edfac63bec54173b4b31eae5c7fb46cd8f714.diff";
      hash = "sha256-KC2oyzcwU2fUmxaed8qAsKcePwR5KcXgpVdstJg8KmU=";
    })
  ];

  cmakeFlags = lib.optional stdenv.isDarwin "-DMOVIES=OFF";

  meta = with lib; {
    description = "A presenter console with multi-monitor support for PDF files";
    homepage = "https://pdfpc.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };

}
