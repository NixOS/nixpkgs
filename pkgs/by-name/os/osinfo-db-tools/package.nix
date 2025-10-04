{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  gettext,
  glib,
  libxml2,
  perl,
  python3,
  libxslt,
  libarchive,
  bzip2,
  xz,
  json-glib,
  libsoup_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osinfo-db-tools";
  version = "1.12.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/osinfo-db-tools-${finalAttrs.version}.tar.xz";
    hash = "sha256-8zFfZ10Ydw8l3qjtBLILj8gO+wD2DDfuXoFfnDd25/M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    perl
    python3
  ];

  buildInputs = [
    glib
    json-glib
    libxml2
    libxslt
    libarchive
    bzip2
    xz
    libsoup_3
  ];

  meta = {
    description = "Tools for managing the osinfo database";
    homepage = "https://libosinfo.org/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db-tools/-/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
