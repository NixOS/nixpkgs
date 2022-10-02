{ lib
, stdenv
, fetchFromGitHub
, glib
, meson
, ninja
, libevdev
, json-glib
, cairo
, pango
, libinput
, gtk4
, wrapGAppsHook
, libxkbcommon
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "showmethekey";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "AlynxZhou";
    repo = "showmethekey";
    rev = "v${version}";
    sha256 = "sha256-hq4X4dG25YauMjsNXC6Flco9pEpVj3EM2JiFWbRrPaA=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    cairo
    pango
    json-glib
    pkg-config
    libevdev
    libinput
    libxkbcommon
    wrapGAppsHook
  ];

  buildInputs = [
    gtk4
  ];

  meta = with lib; {
    homepage = "https://showmethekey.alynx.one/";
    description = "Show keys you typed on screen";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ocfox ];
  };
}
