{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, glib
, meson
, ninja
, libevdev
, json-glib
, cairo
, pango
, libinput
, gtk4
, wrapGAppsHook4
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

  patches = [
    (fetchpatch {
      name = "use-gtk4-update-icon-cache.patch";
      url = "https://github.com/alynxzhou/showmethekey/commit/c73102dc2825d00cbaf323fcfc96736381dc67ae.patch";
      sha256 = "sha256-6QDY5eQ9A8q3LZeD7v6WI/4vYXc/XXVY/WENA1nvIKo=";
    })
  ];

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
    wrapGAppsHook4
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
