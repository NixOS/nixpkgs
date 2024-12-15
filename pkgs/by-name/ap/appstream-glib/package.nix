{
  lib,
  stdenv,
  fetchFromGitHub,
  substituteAll,
  docbook_xml_dtd_42,
  docbook_xsl,
  fontconfig,
  freetype,
  gdk-pixbuf,
  gettext,
  glib,
  gobject-introspection,
  gperf,
  gtk-doc,
  gtk3,
  json-glib,
  libarchive,
  curl,
  libuuid,
  libxslt,
  meson,
  ninja,
  pkg-config,
  pngquant,
}:
stdenv.mkDerivation rec {
  pname = "appstream-glib";
  version = "0.8.2";

  outputs = [
    "out"
    "dev"
    "man"
    "installedTests"
  ];
  outputBin = "dev";

  src = fetchFromGitHub {
    owner = "hughsie";
    repo = "appstream-glib";
    rev = "${lib.replaceStrings [ "-" ] [ "_" ] pname}_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-3QFiOJ38talA0GGL++n+DaA/AN7l4LOZQ7BJV6o8ius=";
  };

  nativeBuildInputs = [
    docbook_xml_dtd_42
    docbook_xsl
    gettext
    gobject-introspection
    gperf
    gtk-doc
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    json-glib
    libarchive
    curl
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
  ];

  patches = [
    (substituteAll {
      src = ./paths.patch;
      pngquant = "${pngquant}/bin/pngquant";
    })
  ];

  mesonFlags = [
    "-Drpm=false"
    "-Dstemmer=false"
    "-Ddep11=false"
  ];

  doCheck = false; # fails at least 1 test

  postInstall = ''
    moveToOutput "share/installed-tests" "$installedTests"
  '';

  meta = with lib; {
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = "https://people.freedesktop.org/~hughsient/appstream-glib/";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
