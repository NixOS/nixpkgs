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

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-podcasts";
  version = "25.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "podcasts";
    tag = finalAttrs.version;
    hash = "sha256-pVGut7kmwybPrR7ZaXPoDx03FOYeZSvchXl++2cdPck=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HKU4rd5OzxhYcN6QKiTVj+NnkdyG8T+D6X1txznZ/xM=";
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
    changelog = "https://gitlab.gnome.org/World/podcasts/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    teams = [
      lib.teams.gnome
      lib.teams.gnome-circle
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/gnome-podcasts.x86_64-darwin
  };
})
