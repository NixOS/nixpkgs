{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, nix-update-script
, meson
, ninja
, gettext
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

stdenv.mkDerivation rec {
  pname = "fractal";
  version = "4.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-To6lr2I+JVrxvuK++2gLWntFGnEBm+B6KTRuOvjASek=";
  };

  patches = [
    # Fix build with meson 0.61
    # fractal-gtk/res/meson.build:5:0: ERROR: Function does not take positional arguments.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/fractal/-/commit/6fa1a23596d65d94aa889efe725174e6cd2903f0.patch";
      hash = "sha256-3OzU9XL2V1VNOkvL1j677K3HNoBqPMQudQDmiDxYfAc=";
    })

    # This is in fractal v4.4.1b1+ so can be removed when fractal is updated.
    ./update-socket2-for-rust-1.64.diff
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    name = "${pname}-${version}";
    hash = "sha256-d99zSaxp22YyLP3Wckgcm7wlz7nFrLJDHq2xPJmZFf0=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
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
    gst_all_1.gst-devtools
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

  preConfigure = ''
    export GETTEXT_DIR="${gettext}"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/GNOME/fractal";
    license = licenses.gpl3;
    maintainers = teams.gnome.members ++ (with maintainers; [ dtzWill ]);
    platforms = platforms.unix;
  };
}
