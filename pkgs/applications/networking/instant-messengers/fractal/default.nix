{ stdenv
, lib
, fetchFromGitLab
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
  version = "4.4.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "fractal";
    rev = version;
    hash = "sha256-/vPadtyiYDX0PdneMxc0oSWb5OYnikevqajl3WgZiGA=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "either-1.5.99" = "sha256-Lmv9OPZKEb7tmkN+7Mua2nx0xmZwm3d1W623UKUlPeg=";
      "gettext-rs-0.4.2" = "sha256-wyZ1bf0oFcQo8gEi2GEalRUoKMoJYHysu79qcfjd4Ng=";
      "sourceview4-0.2.0" = "sha256-RuCg05/qjkPri1QUd5acsGVqJtGvM5OO8/R+Nibxoa4=";
    };
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
