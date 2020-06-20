{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, rofi-unwrapped
, libqalculate
, glib
, cairo
, gobject-introspection
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "rofi-calc";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "046x2zpvza7n0m81s75qkvmnpkvsvvyqqqjxcqzj7by0llpqs7wa";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    gobject-introspection
    wrapGAppsHook
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

  meta = with stdenv.lib; {
    description = "Do live calculations in rofi!";
    homepage = "https://github.com/svenstaro/rofi-calc";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r albakham ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}

