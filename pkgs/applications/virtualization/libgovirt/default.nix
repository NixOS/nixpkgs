{ lib
, stdenv
, fetchurl
, glib
, gnome
, librest
, libsoup
, pkg-config
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libgovirt";
  version = "0.3.8";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgovirt/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "HckYYikXa9+p8l/Y+oLAoFi2pgwcyAfHUH7IqTwPHfg=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    libsoup
  ];

  propagatedBuildInputs = [
    glib
    librest
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/libgovirt";
    description = "GObject wrapper for the oVirt REST API";
    maintainers = [ maintainers.amarshall ];
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
  };
}
