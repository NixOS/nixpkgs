{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "gtk-engines";
  version = "2.20.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-engines/${lib.versions.majorMinor version}/gtk-engines-${version}.tar.bz2";
    sha256 = "1db65pb0j0mijmswrvpgkdabilqd23x22d95hp5kwxvcramq1dhm";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [ gtk2 ];

  meta = {
    description = "Theme engines for GTK 2";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
