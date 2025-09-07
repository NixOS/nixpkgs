{
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gtk4,
  lib,
  libadwaita,
  meson,
  mesonEmulatorHook,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raider";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ADBeveridge";
    repo = "raider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X8VIpxOhfvOIf5CYQOBVrC9T6Dhgz/oMIQCaoRch4Oo=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Permanently delete your files (also named File Shredder)";
    longDescription = ''
      Raider is a shredding program built for the GNOME
      desktop. It is meant to remove files from your
      computer permanently. Within a certain limit, it is
      effective. However, the way data is written physically
      to SSDs at the hardware level ensures that shredding
      is never perfect, and no software can fix that.
      However, top-level agencies are usually the only ones
      who can recover such data, due to the time, effort,
      money and patience required to extract it effectively.
    '';
    homepage = "https://apps.gnome.org/Raider";
    changelog = "https://github.com/ADBeveridge/raider/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "raider";
    maintainers = with lib.maintainers; [
      benediktbroich
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.unix;
  };
})
