{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, substituteAll
, cargo
, desktop-file-utils
, git
, itstool
, meson
, ninja
, pkg-config
, python3
, rustc
, wrapGAppsHook4
, borgbackup
, gtk4
, libadwaita
, libsecret
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.7.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    hash = "sha256-yxr98CJuu15TGiIXCBhU2bOgvct6jQ5xAraD9Z0sL2Q=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-ce8SdBvRdFp1BU9OPcByoJjCiSrAkQqtmfCeJ3B+Piw=";
  };

  patches = [
    (substituteAll {
      src = ./borg-path.patch;
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

  meta = with lib; {
    description = "Simple backups based on borg";
    homepage = "https://apps.gnome.org/app/org.gnome.World.PikaBackup";
    changelog = "https://gitlab.gnome.org/World/pika-backup/-/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
