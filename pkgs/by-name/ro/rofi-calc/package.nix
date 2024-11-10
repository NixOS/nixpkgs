{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, rofi-unwrapped
, libqalculate
, glib
, cairo
, gobject-introspection
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "rofi-calc";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uXaI8dwTRtg8LnFxopgXr9x/vEl8ixzIGOsSQQkAkoQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    rofi-unwrapped
    libqalculate
    glib
    cairo
  ];

  patches = [
    ./0001-Patch-plugindir-to-output.patch
  ];

  postPatch = ''
    sed "s|qalc_binary = \"qalc\"|qalc_binary = \"${libqalculate}/bin/qalc\"|" -i src/calc.c
  '';

  meta = with lib; {
    description = "Do live calculations in rofi!";
    homepage = "https://github.com/svenstaro/rofi-calc";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r albakham ];
    platforms = with platforms; linux;
  };
}

