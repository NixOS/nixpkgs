{ lib
, stdenv
, fetchurl
, glib
, gnome
, librest_1_0
, libsoup
, meson
, ninja
, pkg-config
, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "libgovirt";
  version = "0.3.9";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgovirt/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-sS/DV58tAH5D/vHcwPSz+MEHDC+2o/WLI8U8dmJDIXw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    libsoup
  ];

  propagatedBuildInputs = [
    glib
    librest_1_0
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-error";

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
