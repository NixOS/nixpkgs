{ lib, stdenv, fetchFromGitHub, rustPlatform
, appstream-glib, cargo, desktop-file-utils, glib, libadwaita, meson, ninja
, pkg-config, rustc, wrapGAppsHook4
, dbus, gtk4, sqlite
}:

stdenv.mkDerivation rec {
  pname = "furtherance";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
    rev = "v${version}";
    sha256 = "sha256-l62k7aFyKfYWO+Z85KR8tpwts28pamINHYp/oKuHkhc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-AuXSX+64rJcTChpsE5tqk67bihKkSyimFAMhb1VdbBs=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    sqlite
  ];

  meta = with lib; {
    description = "Track your time without being tracked";
    homepage = "https://github.com/lakoliu/Furtherance";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ CaptainJawZ ];
  };
}
