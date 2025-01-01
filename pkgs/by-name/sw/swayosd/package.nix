{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  brightnessctl,
  cargo,
  coreutils,
  gtk-layer-shell,
  libevdev,
  libinput,
  libpulseaudio,
  meson,
  ninja,
  rustc,
  sassc,
  stdenv,
  udev,
}:
stdenv.mkDerivation rec {
  pname = "swayosd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "v${version}";
    hash = "sha256-GyvRWEzTxQxTAk+xCLFsHdd1SttBliOgJ6eZqAxQMME=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-EUxJ+aGtYAO0kNggNXIZqj2DmPzc4serj0/V+fvH7ds=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    pkg-config
    meson
    rustc
    cargo
    ninja
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    gtk-layer-shell
    libevdev
    libinput
    libpulseaudio
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
