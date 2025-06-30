{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  intltool,
  gobject-introspection,
  glib,
  gdk-pixbuf,
  libxml2,
  cairo,
  pango,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "lasem";
  version = "0.4.4";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "doc"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fds3fsx84ylsfvf55zp65y8xqjj5n8gbhcsk02vqglivk7izw4v";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gobject-introspection
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    libxml2
    cairo
    pango
  ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "SVG and MathML rendering library";
    mainProgram = "lasem-render-0.4";

    homepage = "https://github.com/LasemProject/lasem";
    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
  };
}
