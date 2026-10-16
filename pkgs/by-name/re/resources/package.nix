{
  lib,
  stdenv,
  fetchFromGitLab,
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
  libsoup_3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resources";
  version = "51.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME/Incubator";
    repo = "resources";
    tag = finalAttrs.version;
    hash = "sha256-ZdLBWawoD07SxC+/QTeyOXx7uAyazP6XjLeTF6lsWRw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-m4LwmA5mwd2bUK5X26HJvIr6hxf75O+9WGEfYVthSh0=";
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
    libsoup_3
  ];

  # Check all Command::new
  runtimeDeps = [
    dmidecode
    util-linux # lscpu
    systemd # udevadm
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps})
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Monitor your system resources and processes";
    homepage = "https://gitlab.gnome.org/GNOME/Incubator/resources";
    license = lib.licenses.gpl3Plus;
    mainProgram = "resources";
    maintainers = with lib.maintainers; [
      lukas-heiligenbrunner
      ewuuwe
      graysontinker
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
})
