{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "appstream-glib";
  version = "0.8.3";

  strictDeps = true;
  __structuredAttrs = true;

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
    tag = "appstream_glib_${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-GjXrYV+EBduhG88LaxQWICKuUDJeeotcZgqgaG0/dqo=";
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
    (replaceVars ./paths.patch {
      pngquant = "${pngquant}/bin/pngquant";
    })
  ];

  mesonFlags = [
    "-Drpm=false"
    "-Ddep11=false"
  ];

  doCheck = false; # fails at least 1 test

  postInstall = ''
    moveToOutput "share/installed-tests" "$installedTests"
  '';

  meta = {
    changelog = "https://github.com/hughsie/appstream-glib/blob/${finalAttrs.src.tag}/NEWS";
    description = "Objects and helper methods to read and write AppStream metadata";
    homepage = "https://people.freedesktop.org/~hughsient/appstream-glib/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
