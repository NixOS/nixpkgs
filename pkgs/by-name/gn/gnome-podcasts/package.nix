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
, glib-networking
, sqlite
, gst_all_1
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    hash = "sha256-KCjHT/4AeJ+RXCtawkhs6f4D8NCJotYIPk3tGr5YG9M=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-XTfKqKs7874ak7Lzscxw8E2qcnJOWMZaaol8TpIB6Vw=";
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
    glib-networking
    sqlite
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
  ];

  # tests require network
  doCheck = false;

  meta = {
    description = "Listen to your favorite podcasts";
    mainProgram = "gnome-podcasts";
    homepage = "https://apps.gnome.org/Podcasts/";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.gnome.members;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
}
