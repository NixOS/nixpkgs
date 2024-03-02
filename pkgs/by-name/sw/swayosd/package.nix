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
  version = "unstable-2023-09-26";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "1c7d2f5b3ee262f25bdd3c899eadf17efb656d26";
    hash = "sha256-Y22O6Ktya/WIhidnoyxnZu5YvXWNmSS6vecDU8zDD34=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-tqbMlygX+n14oR1t+0ngjiSG2mHUk/NbiWHk4yEAb2o=";
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
    maintainers = with maintainers; [ aleksana barab-i ];
    platforms = platforms.linux;
  };
}
