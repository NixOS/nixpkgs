{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, brightnessctl
, cargo
, coreutils
, gtk-layer-shell
, libevdev
, libinput
, libpulseaudio
, meson
, ninja
, rustc
, sassc
, stdenv
, udev
}:

stdenv.mkDerivation rec {
  pname = "swayosd";
  version = "0-unstable-2024-04-15";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "11271760052c4a4a4057f2d287944d74e8fbdb58";
    hash = "sha256-qOxnl2J+Ivx/TIqodv3a8nP0JQsYoKIrhqnbD9IxU8g=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-exbVanUvGp0ub4WE3VcsN8hkcK0Ipf0tNfd92UecICg=";
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
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana barab-i sergioribera ];
    platforms = platforms.linux;
  };
}
