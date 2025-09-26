{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cairo,
  glib,
  gobject-introspection,
  libgtop,
  pkg-config,
  rofi-unwrapped,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "rofi-top";
  version = "0-unstable-2017-10-16";

  src = fetchFromGitHub {
    owner = "davatorium";
    repo = "rofi-top";
    rev = "9416addf91dd1bd25dfd5a8c5f1c7297c444408e";
    sha256 = "sha256-lNsmx1xirepITpUD30vpcs5slAQYQcvDW8FkA2K9JtU=";
  };

  patches = [
    ./0001-Patch-plugindir-to-output.patch
    ./0002-Patch-add-cairo.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    glib
    libgtop
    rofi-unwrapped
  ];

  meta = with lib; {
    description = "Plugin for rofi that emulates top behaviour";
    homepage = "https://github.com/davatorium/rofi-top";
    license = licenses.mit;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
  };
}
