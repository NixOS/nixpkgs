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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resources";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z4ZVj/nS4n3oqENSK87YJ8sQRnqK7c4tWzKHUD0Qw2s=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jHdEiK3nu9mN2A6biHq9Iu4bSniD74hGnKFBTt5xVDM=";
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

  postPatch = ''
    substituteInPlace src/utils/memory.rs \
      --replace '"dmidecode"' '"${dmidecode}/bin/dmidecode"'
    substituteInPlace src/utils/cpu.rs \
      --replace '"lscpu"' '"${util-linux}/bin/lscpu"'
    substituteInPlace src/utils/memory.rs \
      --replace '"pkexec"' '"/run/wrappers/bin/pkexec"'
  '';

  mesonFlags = [
    (lib.mesonOption "profile" "default")
  ];

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
