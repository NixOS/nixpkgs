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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "v${version}";
    hash = "sha256-O9A7+QvvhmH3LFLv8vufVCgNQJqKc3LJitCUHYaGHyE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-J2sl6/4+bRWlkvaTJtFsMqvvOxYtWLRjJcYWcu0loRE=";
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

  meta = with lib; {
    description = "GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      aleksana
      barab-i
      sergioribera
    ];
    platforms = platforms.linux;
  };
}
