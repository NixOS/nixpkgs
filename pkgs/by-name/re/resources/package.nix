{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  autoAddDriverRunpath,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  dmidecode,
  util-linux,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resources";
  version = "1.10.1-1";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NjzHGz90MhdjBHP88+qBI/5usCpPPrukSaVHoOJJXSI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wATJxWemn5VxRsRat5I4uEnymsfMM6AX+hP422cUtBo=";
  };

  nativeBuildInputs = [
    appstream-glib
    autoAddDriverRunpath
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  # Check all Command::new
  runtimeDeps = [
    dmidecode
    util-linux # lscpu
    systemd # udevadm
  ];

  mesonFlags = [
    (lib.mesonOption "profile" "default")
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps})
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/nokyan/resources/releases/tag/v${finalAttrs.version}";
    description = "Monitor your system resources and processes";
    homepage = "https://github.com/nokyan/resources";
    license = lib.licenses.gpl3Only;
    mainProgram = "resources";
    maintainers = with lib.maintainers; [
      lukas-heiligenbrunner
      ewuuwe
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
