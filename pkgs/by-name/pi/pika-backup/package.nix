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
  openssl,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.8.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    tag = version;
    hash = "sha256-02ChjIXjTos3jm6UR37tFWhRlUvyh/1r6zLsd6fQsyc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-e6hep/aTpC5HDI/UoSJONGZRP3rjA2eVh9G4DE3HJpE=";
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
    openssl
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
