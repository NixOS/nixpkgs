{ lib
, stdenv
, fetchurl
, glib
, librest
, libsoup
, pkg-config
}:

with lib;

stdenv.mkDerivation rec {
  pname = "libgovirt";
  version = "0.3.8";

  src = fetchurl {
    url = "https://download.gnome.org/sources/libgovirt/0.3/${pname}-${version}.tar.xz";
    sha256 = "sha256-HckYYikXa9+p8l/Y+oLAoFi2pgwcyAfHUH7IqTwPHfg=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    librest
    libsoup
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/libgovirt";
    description = "GObject wrapper for the oVirt REST API";
    maintainers = [ maintainers.amarshall ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
