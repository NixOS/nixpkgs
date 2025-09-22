{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  vala,
  gtk3,
  libgee,
  poppler,
  libpthreadstubs,
  gstreamer,
  gst-plugins-base,
  gst-plugins-good,
  gst-libav,
  gobject-introspection,
  wrapGAppsHook3,
  qrencode,
  webkitgtk_4_1,
  discount,
  json-glib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "pdfpc";
  version = "4.7.0";

  src = fetchFromGitHub {
    repo = "pdfpc";
    owner = "pdfpc";
    rev = "v${version}";
    hash = "sha256-fPhCrn1ELC03/II+e021BUNJr1OKCBIcFCM7z+2Oo+s=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    vala
    # For setup hook
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libgee
    poppler
    libpthreadstubs
    gstreamer
    gst-plugins-base
    (gst-plugins-good.override { gtkSupport = true; })
    gst-libav
    qrencode
    webkitgtk_4_1
    discount
    json-glib
  ];

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin (lib.cmakeBool "MOVIES" false);

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Presenter console with multi-monitor support for PDF files";
    mainProgram = "pdfpc";
    homepage = "https://pdfpc.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
  };

}
