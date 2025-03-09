{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  gettext,
  pkg-config,
  rustc,
  glib,
  gtk4,
  libadwaita,
  appstream-glib,
  desktop-file-utils,
  dbus,
  openssl,
  glib-networking,
  sqlite,
  gst_all_1,
  wrapGAppsHook4,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gnome-podcasts";
  version = "0.7.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    rev = version;
    hash = "sha256-xPB1ieOgnHe2R5ORK0Hl61V+iDZ7WsJEnsAJGZvQUVI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-Nzfsr1OFw7DnxrNol00BI9WIe1Tau3z/R4zdF0PaBOk=";
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Listen to your favorite podcasts";
    mainProgram = "gnome-podcasts";
    homepage = "https://apps.gnome.org/Podcasts/";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.gnome.members ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
}
