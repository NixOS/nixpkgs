{ stdenv
, fetchFromGitLab
, nix-update-script
, fetchpatch
, meson
, ninja
, gettext
, cargo
, rustc
, python3
, rustPlatform
, pkg-config
, gtksourceview4
, glib
, libhandy_0
, gtk3
, dbus
, openssl
, sqlite
, gst_all_1
, cairo
, gdk-pixbuf
, gspell
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "fractal";
  version = "4.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    sha256 = "DSNVd9YvI7Dd3s3+M0+wE594tmL1yPNMnD1W9wLhSuw=";
  };

  cargoSha256 = "xim5sOzeXJjRXbTOg2Gk/LHU0LioiyMK5nSr1LwMPjc=";

  nativeBuildInputs = [
    cargo
    gettext
    meson
    ninja
    pkg-config
    python3
    rustc
    wrapGAppsHook
    glib
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gspell
    gst_all_1.gst-editing-services
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override {
      gtkSupport = true;
    })
    gst_all_1.gstreamer
    gst_all_1.gst-validate
    gtk3
    gtksourceview4
    libhandy_0
    openssl
    sqlite
  ];

  postPatch = ''
    chmod +x scripts/test.sh
    patchShebangs scripts/meson_post_install.py scripts/test.sh
  '';

  # Don't use buildRustPackage phases, only use it for rust deps setup
  configurePhase = null;
  buildPhase = null;
  checkPhase = null;
  installPhase = null;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill worldofpeace ];
  };
}
