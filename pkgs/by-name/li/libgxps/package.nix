{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  glib,
  gobject-introspection,
  cairo,
  libarchive,
  freetype,
  libjpeg,
  libtiff,
  gnome,
  lcms2,
}:

stdenv.mkDerivation rec {
  pname = "libgxps";
  version = "0.3.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bSeGclajXM+baSU+sqiKMrrKO5fV9O9/guNmf6Q1JRw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
  ];
  buildInputs = [
    glib
    cairo
    freetype
    libjpeg
    libtiff
    lcms2
  ];
  propagatedBuildInputs = [ libarchive ];

  mesonFlags =
    [
      "-Denable-test=false"
    ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "-Ddisable-introspection=true"
    ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GObject based library for handling and rendering XPS documents";
    homepage = "https://gitlab.gnome.org/GNOME/libgxps";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.unix;
  };
}
