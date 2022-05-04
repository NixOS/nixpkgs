{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
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
    # Fix build with meson 0.61, can be removed on next release.
    # https://gitlab.gnome.org/World/pika-backup/-/issues/156
    # https://github.com/mesonbuild/meson/issues/9441
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/pika-backup/-/commit/54be149c88fd69fb9e74b7362fe7182863237869.patch";
      sha256 = "sha256-Tffxo5hlf/gSkp1GfyL4eHthX49tuTq6B+S53N8oA2M=";
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
    platforms = platforms.linux;
  };
}
