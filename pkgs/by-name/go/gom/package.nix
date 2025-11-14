{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  python3,
  sqlite,
  gdk-pixbuf,
  gnome,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "gom";
  version = "0.5.5";

  outputs = [
    "out"
    "py"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gom/${lib.versions.majorMinor version}/gom-${version}.tar.xz";
    sha256 = "rWHwWvIxenqxdx/PqBaYn7ujsYlX0uC13t6e9F8JtTQ=";
  };

  patches = [
    ./longer-stress-timeout.patch
  ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    sqlite
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dpygobject-override-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  # Success is more likely on x86_64
  doCheck = stdenv.hostPlatform.isx86_64;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gom";
    };
  };

  meta = with lib; {
    description = "GObject to SQLite object mapper";
    homepage = "https://gitlab.gnome.org/GNOME/gom";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}
