{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  brightnessctl,
  cargo,
  coreutils,
  dbus,
  gtk4-layer-shell,
  libevdev,
  libinput,
  libpulseaudio,
  meson,
  ninja,
  rustc,
  sassc,
  stdenv,
  udev,
  udevCheckHook,
}:
stdenv.mkDerivation rec {
  pname = "swayosd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "v${version}";
    hash = "sha256-DRJ4D+QcgkVZmlfbj2HEIUHnYldzIuSDcpsOAOuoaL0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-t0IZvO7Wbx6A7v/sRZOSOLj0O/1m7vOBjZSd99TAutI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    pkg-config
    meson
    rustc
    cargo
    ninja
    rustPlatform.cargoSetupHook
    udevCheckHook
  ];

  buildInputs = [
    gtk4-layer-shell
    libevdev
    libinput
    libpulseaudio
    dbus
    udev
    sassc
  ];

  patches = [
    ./swayosd_systemd_paths.patch
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ brightnessctl ]}
    )
  '';

  postPatch = ''
    substituteInPlace data/udev/99-swayosd.rules \
      --replace /bin/chgrp ${coreutils}/bin/chgrp \
      --replace /bin/chmod ${coreutils}/bin/chmod
  '';

  doInstallCheck = true;

  meta = {
    description = "GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aleksana
      barab-i
      sergioribera
    ];
    platforms = lib.platforms.linux;
  };
}
