{ lib
, rustPlatform
, fetchFromGitLab
, meson
, ninja
, pkg-config
, wrapGAppsHook
, gdk-pixbuf
, glib
, gtk3
, libhandy
, openssl
, sqlite
, webkitgtk
, glib-networking
, librsvg
, gst_all_1
}:

rustPlatform.buildRustPackage rec {
  pname = "newsflash";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    rev = version;
    sha256 = "sha256-5GuQoLMQ6p4B5vnY5Viad3rjkyZX3aWeVeycozM7pCE=";
  };

  cargoSha256 = "sha256-xBH3+VTV6hlF1sg/Iaw6Z64Z8VpUhpbAHn/S/L9ymOI=";

  patches = [
    ./no-post-install.patch
  ];

  postPatch = ''
    chmod +x build-aux/cargo.sh
    patchShebangs .
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook

    # Provides setup hook to fix "Unrecognized image file format"
    gdk-pixbuf

    # Provides glib-compile-resources to compile gresources
    glib
  ];

  buildInputs = [
    gtk3
    libhandy
    openssl
    sqlite
    webkitgtk

    # TLS support for loading external content in webkitgtk WebView
    glib-networking

    # SVG support for gdk-pixbuf
    librsvg
  ] ++ (with gst_all_1; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  # Unset default rust phases to use meson & ninja instead
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;
  installCheckPhase = null;

  meta = with lib; {
    description = "A modern feed reader designed for the GNOME desktop";
    homepage = "https://gitlab.com/news-flash/news_flash_gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
  };
}
