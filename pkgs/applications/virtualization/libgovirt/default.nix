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

  patches = lib.optionals stdenv.isDarwin [
    # The flag breaks the build on darwin and doesn't seem necessary
    ./no-version-script-ld-flag.patch
  ];

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
    maintainers = with maintainers; [ amarshall atemu ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.lgpl21Plus;
  };
}
