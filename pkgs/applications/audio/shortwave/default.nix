{ stdenv
, fetchFromGitLab
, cargo
, dbus
, desktop-file-utils
, gdk-pixbuf
, gettext
, glib
, gst_all_1
, gtk3
, libhandy
, meson
, ninja
, openssl
, pkg-config
, python3
, rust
, rustc
, rustPlatform
, sqlite
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "shortwave";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "13lhlh75vw02vkcknl4nvy0yvpdf0qx811mmyja8bzs4rj1j9kr8";
  };

  cargoSha256 = "0aph5z54a6i5p8ga5ghhx1c9hjc8zdw5pkv9inmanca0bq3hkdlh";

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    gettext
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    python3
    rustc
    wrapGAppsHook
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk3
    libhandy
    openssl
    sqlite
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://gitlab.gnome.org/World/Shortwave";
    description = "Find and listen to internet radio stations";
    longDescription = ''
      Shortwave is a streaming audio player designed for the GNOME
      desktop. It is the successor to the older Gradio application.
    '';
    maintainers = with maintainers; [ lasandell ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
