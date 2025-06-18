{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  libevdev,
  json-glib,
  libinput,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  libxkbcommon,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "showmethekey";
  version = "1.18.3";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "showmethekey";
    tag = "v${version}";
    hash = "sha256-vVcP+m6rZgNti/NEk4fQpZ8bkv4z13NIZN1p/eVmBI4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    json-glib
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libevdev
    libinput
    libxkbcommon
  ];

  meta = {
    description = "Show keys you typed on screen";
    homepage = "https://showmethekey.alynx.one/";
    changelog = "https://github.com/AlynxZhou/showmethekey/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ocfox ];
  };
}
