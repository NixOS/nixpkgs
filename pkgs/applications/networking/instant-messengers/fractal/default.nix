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
, pkgconfig
, gtksourceview4
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
  version = "4.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    sha256 = "0r98km3c8naj3mdr1wppzj823ir7jnsia7r3cbg3vsq8q52i480r";
  };

  cargoSha256 = "10fgw9m6gdazrca73g43sgvsghhac7xc3bg7hr0vpynzqyfigwa9";

  nativeBuildInputs = [
    cargo
    gettext
    meson
    ninja
    pkgconfig
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
    gst_all_1.gstreamer
    gst_all_1.gst-validate
    gtk3
    gtksourceview4
    libhandy
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
