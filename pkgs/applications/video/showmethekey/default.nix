{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, libevdev
, json-glib
, libinput
, gtk4
, wrapGAppsHook4
, libxkbcommon
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "showmethekey";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iWZjOhugGD7GikcIKaJimfLrTDaGQeYgmp17N03Meb8=";
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
    libevdev
    libinput
    libxkbcommon
  ];

  meta = with lib; {
    homepage = "https://showmethekey.alynx.one/";
    description = "Show keys you typed on screen";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocfox ];
  };
}
