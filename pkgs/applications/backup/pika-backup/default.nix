{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, substituteAll
, desktop-file-utils
, git
, itstool
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, borgbackup
, gtk4
, libadwaita
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.5.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    hash = "sha256-d+VkKY14o1wwINSlVBsvWux8YhyXg77N9i2R61QLGqM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-3MNwX8kB+bjP9Dz+k+HYmCOI1Naa9tDBe0+GKsEmqnc=";
  };

  patches = [
    (substituteAll {
      src = ./borg-path.patch;
      borg = "${borgbackup}/bin/borg";
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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk4
    libadwaita
    libsecret
  ];

  meta = with lib; {
    description = "Simple backups based on borg";
    homepage = "https://apps.gnome.org/app/org.gnome.World.PikaBackup";
    changelog = "https://gitlab.gnome.org/World/pika-backup/-/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
