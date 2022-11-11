{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, vala, gtk3, libgee
, poppler, libpthreadstubs, gstreamer, gst-plugins-base, gst-plugins-good, gst-libav, librsvg, pcre, gobject-introspection, wrapGAppsHook
, webkitgtk, discount, json-glib }:

stdenv.mkDerivation rec {
  pname = "pdfpc";
  version = "4.5.0";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    sha256 = "0bmy51w6ypz927hxwp5g7wapqvzqmsi3w32rch6i3f94kg1152ck";
  };

  nativeBuildInputs = [
    cmake pkg-config vala
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
    webkitgtk
    discount
    json-glib
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
