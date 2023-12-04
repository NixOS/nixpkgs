{ stdenv
, lib
, rustPlatform
, fetchFromGitLab
, cargo
, meson
, ninja
, gettext
, pkg-config
, rustc
, glib
, gtk4
, libadwaita
, appstream-glib
, desktop-file-utils
, dbus
, openssl
, sqlite
, gst_all_1
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
  version = "0.6.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    hash = "sha256-LPwCYgAFgUMFQZ0i4ldiuGYGMMWcMqYct3/o7eTIhmU=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gettext
    dbus
    openssl
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  # tests require network
  doCheck = false;

  meta = with lib; {
    description = "Listen to your favorite podcasts";
    homepage = "https://wiki.gnome.org/Apps/Podcasts";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
}
