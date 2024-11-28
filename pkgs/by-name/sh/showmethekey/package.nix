{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, libevdev
, json-glib
, libinput
, gtk4
, libadwaita
, wrapGAppsHook4
, libxkbcommon
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "showmethekey";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "showmethekey";
    rev = "refs/tags/v${version}";
    hash = "sha256-d+k7EbGrFWOztr/e+ugnXVP/hUZAIEgmLDvQDf18K48=";
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

  meta = with lib; {
    description = "Show keys you typed on screen";
    homepage = "https://showmethekey.alynx.one/";
    changelog = "https://github.com/AlynxZhou/showmethekey/releases/tag/v${version}";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocfox ];
  };
}
