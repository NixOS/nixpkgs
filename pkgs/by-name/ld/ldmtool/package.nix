{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gtk-doc,
  pkg-config,
  libuuid,
  libtool,
  readline,
  gobject-introspection,
  json-glib,
  lvm2,
  libxslt,
  docbook_xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldmtool";
  version = "0.2.5-unstable-2025-02-06";

  src = fetchFromGitHub {
    owner = "mdbooth";
    repo = "libldm";
    rev = "1eafb653ac6347a9d4281848c8295f9daffb1613";
    hash = "sha256-Vd+3FnM+U5y2FxuslEsEzgZEx+5AQWuTjUVRnoFhm3I=";
  };

  preConfigure = ''
    sed -i docs/reference/ldmtool/Makefile.am \
      -e 's|-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|--nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl|g'
  '';

  configureScript = "sh autogen.sh";

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    gobject-introspection
  ];
  buildInputs = [
    gtk-doc
    lvm2
    libxslt.bin
    libtool
    readline
    json-glib
    libuuid
  ];

  meta = {
    description = "Tool and library for managing Microsoft Windows Dynamic Disks";
    homepage = "https://github.com/mdbooth/libldm";
    maintainers = with lib.maintainers; [ jensbin ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "ldmtool";
  };
})
