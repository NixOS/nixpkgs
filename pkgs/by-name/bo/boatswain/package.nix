{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  gtk4,
  libgee,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  libpeas,
  libportal-gtk4,
  gusb,
  hidapi,
  json-glib,
  libsecret,
  libsoup_3,
  libpeas2,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "boatswain";
  version = "5.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "boatswain";
    tag = version;
    hash = "sha256-XE4MxaV9BXl5EQjumO/6HhRHfAyjjc5BeYFPAa+mdWY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    libpeas
    libportal-gtk4
    gusb
    hidapi
    json-glib
    libsecret
    libsoup_3
    libpeas2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Control Elgato Stream Deck devices";
    homepage = "https://gitlab.gnome.org/World/boatswain";
    mainProgram = "boatswain";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0xMRTT ] ++ lib.teams.gnome-circle.members;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
