{ lib, stdenv, fetchFromGitHub, rustPlatform, appstream-glib, desktop-file-utils
, glib, libadwaita, meson, ninja, pkg-config, wrapGAppsHook4, dbus , gtk4, sqlite }:

stdenv.mkDerivation rec {
  pname = "furtherance";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "lakoliu";
    repo = "Furtherance";
    rev = "v${version}";
    sha256 = "xshZpwL5AQvYSPoyt9Qutaym5IGBQHWwz4ev3xnVcSk=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "J/e8NYd9JjmANj+4Eh3/Uq2/vS711CwERgmJ7i5orNw=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
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
