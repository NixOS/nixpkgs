{ stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, gettext
, cargo
, rustc
, python3
, rustPlatform
, pkgconfig
, gtksourceview
, hicolor-icon-theme
, glib
, libhandy
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
  version = "4.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    sha256 = "0clwsmd6h759bzlazfq5ig56dbx7npx3h43yspk87j1rm2dp1177";
  };

  cargoSha256 = "1hwjajkphl5439dymglgj3h92hxgbf7xpipzrga7ga8m10nx1dhl";

  nativeBuildInputs = [
    cargo
    gettext
    meson
    ninja
    pkgconfig
    python3
    rustc
    wrapGAppsHook
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
    gst_all_1.gstreamer
    gtk3
    gtksourceview
    hicolor-icon-theme
    libhandy
    openssl
    sqlite
  ];

  cargoPatches = [
    # https://gitlab.gnome.org/GNOME/fractal/merge_requests/446
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/fractal/commit/2778acdc6c50bc6f034513029b66b0b092bc4c38.patch";
      sha256 = "08v17xmbwrjw688ps4hsnd60d5fm26xj72an3zf6yszha2b97j6y";
    })
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

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = https://gitlab.gnome.org/GNOME/fractal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill worldofpeace ];
  };
}

