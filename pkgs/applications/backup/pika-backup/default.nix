{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, substituteAll
, desktop-file-utils
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
  version = "0.4.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    hash = "sha256-D5QkNgscvNaPEykbcR451Wx8Mvn7HTuQE/22lp95Kbo=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-c4nYlPyc7D1AMOfHjhoDJox+i83+H1YKfWzR3i6bmng=";
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
