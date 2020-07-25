{ lib
, rustPlatform
, fetchFromGitLab
, gdk-pixbuf
, glib
, meson
, ninja
, pkg-config
, wrapGAppsHook
, glib-networking
, gsettings-desktop-schemas
, gtk3
, libhandy
, librsvg
, openssl
, sqlite
, webkitgtk
}:

rustPlatform.buildRustPackage rec {
  pname = "newsflash";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "news-flash";
    repo = "news_flash_gtk";
    rev = version;
    sha256 = "1y2jj3z08m29s6ggl8q270mqnvdwibs0f2kxybqhi8mya5pyw902";
  };

  cargoPatches = [
    ./cargo.lock.patch
  ];

  cargoSha256 = "0z3nhzpyckga112wn32zzwwlpqdgi6n53n8nwgggixvpbnh98112";

  patches = [
    ./no-post-install.patch
  ];

  postPatch = ''
    chmod +x build-aux/cargo.sh
    patchShebangs .
  '';

  nativeBuildInputs = [
    gdk-pixbuf # provides setup hook to fix "Unrecognized image file format"
    glib # provides glib-compile-resources to compile gresources
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    glib-networking # TLS support for loading external content in webkitgtk WebView (eg. images)
    gsettings-desktop-schemas # used to get system default font in src/article_view/mod.rs
    gtk3
    libhandy
    librsvg # used by gdk-pixbuf & wrapGAppsHook setup hooks to fix "Unrecognized image file format"
    openssl
    sqlite
    webkitgtk
  ];

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
    platforms = platforms.all;
  };
}
