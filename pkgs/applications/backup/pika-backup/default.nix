{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "pika-backup";
    rev = "v${version}";
    hash = "sha256-vQ0hlwsrY0WOUc/ppleE+kKRGHPt/ScEChXrkukln3U=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-IKUh5gkXTpmMToDaec+CpCIQqJjwJM2ZrmGQhZeTDsg=";
  };

  patches = [
    (substituteAll {
      src = ./borg-path.patch;
      borg = "${borgbackup}/bin/borg";
    })
    (fetchpatch {
      name = "use-gtk4-update-icon-cache.patch";
      url = "https://gitlab.gnome.org/World/pika-backup/-/merge_requests/64.patch";
      hash = "sha256-AttGQGWealvTIvPwBl5M6FiC4Al/UD4/XckUAxM38SE=";
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
