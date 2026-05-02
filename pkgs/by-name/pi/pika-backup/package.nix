{
  lib,
  stdenv,
  fetchFromGitLab,
  rustPlatform,
  replaceVars,
  cargo,
  desktop-file-utils,
  git,
  itstool,
  meson,
  ninja,
  pkg-config,
  python3,
  rustc,
  wrapGAppsHook4,
  borgbackup,
  gtk4,
  libadwaita,
  libsecret,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.8.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    tag = version;
    hash = "sha256-Ee++3EQcfM5/x3QJtsq4UBV6LiKN45WLQVgAVqU8pic=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-gfO+R9jj5mPcpWukp84yqg+iKKE+qrIdNzOHCa7oQpU=";
  };

  patches = [
    (replaceVars ./borg-path.patch {
      borg = lib.getExe borgbackup;
    })
  ];

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    desktop-file-utils
    git
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk4
    libadwaita
    libsecret
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple backups based on borg";
    homepage = "https://apps.gnome.org/app/org.gnome.World.PikaBackup";
    changelog = "https://gitlab.gnome.org/World/pika-backup/-/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
}
