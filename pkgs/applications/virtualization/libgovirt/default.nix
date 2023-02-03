{ lib
, stdenv
, fetchzip
, gnome
, meson
, pkg-config
, gobject-introspection
, ninja
, glib
, librest_1_0
}:

stdenv.mkDerivation rec {
  pname = "libgovirt";
  version = "0.3.9";

  outputs = [ "out" "dev" ];

  src = fetchzip {
    url = "mirror://gnome/sources/libgovirt/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-6RDuJTyaVYlO4Kq+niQyepom6xj1lqdBbyWL/VnZUdk=";
  };

  patches = [
    # https://gitlab.gnome.org/GNOME/libgovirt/-/issues/9
    ./auto-disable-incompatible-compiler-warnings.patch
  ];
  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (lib.concatStringsSep " " [
    "-Wno-typedef-redefinition"
    "-Wno-missing-field-initializers"
    "-Wno-cast-align"
  ]);

  nativeBuildInputs = [
    meson
    pkg-config
    gobject-introspection
    ninja
  ];

  propagatedBuildInputs = [
    glib
    librest_1_0
  ];

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
