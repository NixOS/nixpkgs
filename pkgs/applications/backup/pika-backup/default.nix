{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, substituteAll
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, borgbackup
, dbus
, gdk-pixbuf
, glib
, gtk3
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "pika-backup";
  version = "0.3.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    sha256 = "sha256-dKVyvB4s1MZHri0dFJDBUXQKsi2KgP30ZhsJ486M+og=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1vsh8vqgmfady82d7wfxkknmrp7mq7nizpif2zwg3kqbl964mp3y";
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
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk3
    libhandy
  ];

  meta = with lib; {
    description = "Simple backups based on borg";
    homepage = "https://wiki.gnome.org/Apps/PikaBackup";
    changelog = "https://gitlab.gnome.org/World/pika-backup/-/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
