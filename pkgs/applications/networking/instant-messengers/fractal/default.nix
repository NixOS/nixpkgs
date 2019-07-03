{ stdenv, fetchFromGitLab, meson, ninja, gettext, cargo, rustc, python3, rustPlatform, pkgconfig, gtksourceview
, hicolor-icon-theme, glib, libhandy, gtk3, libsecret, dbus, openssl, sqlite, gst_all_1, wrapGAppsHook, fetchpatch }:

rustPlatform.buildRustPackage rec {
  version = "4.0.0";
  name = "fractal-${version}";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    sha256 = "05q47jdgbi5jz01280msb8gxnbsrgf2jvglfm6k40f1xw4wxkrzy";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext cargo rustc python3 wrapGAppsHook
  ];
  buildInputs = [
    glib gtk3 libhandy dbus openssl sqlite gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-bad
    gtksourceview hicolor-icon-theme libsecret
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

  cargoSha256 = "1ax5dv200v8mfx0418bx8sbwpbp6zj469xg75hp78kqfiv83pn1g";

  meta = with stdenv.lib; {
    description = "Matrix group messaging app";
    homepage = https://gitlab.gnome.org/GNOME/fractal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}

