{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, cargo
, coreutils
, gtk-layer-shell
, libevdev
, libinput
, libpulseaudio
, meson
, ninja
, rustc
, stdenv
, udev
}:

stdenv.mkDerivation rec {
  pname = "swayosd";
  version = "unstable-2023-07-18";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "b14c83889c7860c174276d05dec6554169a681d9";
    hash = "sha256-MJuTwEI599Y7q+0u0DMxRYaXsZfpksc2csgnK9Ghp/E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-pExpzQwuHREhgkj+eZ8drBVsh/B3WiQBBh906O6ymFw=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
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
  ];

  patches = [
    ./swayosd_systemd_paths.patch
  ];

  postPatch = ''
    substituteInPlace data/udev/99-swayosd.rules \
      --replace /bin/chgrp ${coreutils}/bin/chgrp \
      --replace /bin/chmod ${coreutils}/bin/chmod
  '';

  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
