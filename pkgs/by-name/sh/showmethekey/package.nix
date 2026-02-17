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

stdenv.mkDerivation (finalAttrs: {
  pname = "showmethekey";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "showmethekey";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jQRckUqLe9sshi3SJqpFwSsy5H0Gp17kkcCdslwg6cM=";
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
    changelog = "https://github.com/AlynxZhou/showmethekey/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ocfox ];
  };
})
