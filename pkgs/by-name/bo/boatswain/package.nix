{
  lib,
  stdenv,
  appstream,
  desktop-file-utils,
  fetchFromGitLab,
  glib,
  graphene,
  gtk4,
  gusb,
  hidapi,
  json-glib,
  libadwaita,
  libpeas2,
  libportal-gtk4,
  libsecret,
  libsoup_3,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "boatswain";
  version = "5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "boatswain";
    tag = finalAttrs.version;
    hash = "sha256-XE4MxaV9BXl5EQjumO/6HhRHfAyjjc5BeYFPAa+mdWY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    glib
    gtk4
    json-glib
    libpeas2
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    graphene
    gtk4
    gusb
    hidapi
    libadwaita
    libpeas2
    libportal-gtk4
    libsecret
    libsoup_3
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Control Elgato Stream Deck devices";
    homepage = "https://gitlab.gnome.org/World/boatswain";
    changelog = "https://gitlab.gnome.org/World/boatswain/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _0xMRTT ];
    teams = [ lib.teams.gnome-circle ];
    mainProgram = "boatswain";
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
