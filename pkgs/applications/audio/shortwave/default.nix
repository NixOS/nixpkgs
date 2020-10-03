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
, libhandy_0
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
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Shortwave";
    rev = version;
    sha256 = "1vlhp2ss06j41simjrrjg38alp85jddhqyvccy6bhfzm0gzynwld";
  };

  cargoSha256 = "181699rlpr5dszc18wg0kbss3gfskxaz9lpxpgsc4yfb6ip89qnk";

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
    libhandy_0
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
