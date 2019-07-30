{ stdenv
, fetchFromGitLab
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
, libsecret
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "fractal";
  version = "4.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    sha256 = "05q47jdgbi5jz01280msb8gxnbsrgf2jvglfm6k40f1xw4wxkrzy";
  };

  cargoSha256 = "1ax5dv200v8mfx0418bx8sbwpbp6zj469xg75hp78kqfiv83pn1g";

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
    dbus
    glib
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    gtk3
    gtksourceview
    hicolor-icon-theme
    libhandy
    libsecret
    openssl
    sqlite
  ];

  patches = [
    # Fixes build with >= gstreamer 1.15.1
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/fractal/commit/e78f36c25c095ea09c9c421187593706ad7c4065.patch";
      sha256 = "1qv7ayhkhgrrldag2lzs9ql17nbc1d72j375ljhhf6cms89r19ir";
    })
  ];

  postPatch = ''
    patchShebangs scripts/meson_post_install.py
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

