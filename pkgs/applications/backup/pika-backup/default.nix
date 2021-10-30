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
  version = "0.3.5";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    sha256 = "sha256-8jT3n+bTNjhm64AMS24Ju+San75ytfqFXloH/TOgO1g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "198bs4z7l22sh8ck7v46s45mj8zpfbg03n1xzc6pnafdd8hf3q15";
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
