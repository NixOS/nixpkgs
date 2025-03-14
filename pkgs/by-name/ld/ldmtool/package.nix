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
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "ldmtool";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "mdbooth";
    repo = "libldm";
    rev = "libldm-${version}";
    sha256 = "1fy5wbmk8kwl86lzswq0d1z2j5y023qzfm2ppm8knzv9c47kniqk";
  };

  patches = [
    # Remove usage of deprecrated G_PARAM_PRIVATE
    (fetchpatch {
      url = "https://github.com/mdbooth/libldm/commit/ee1b37a034038f09d61b121cc8b3651024acc46f.patch";
      sha256 = "02y34kbcpcpffvy1n9yqngvdldmxmvdkha1v2xjqvrnclanpigcp";
    })
  ];

  preConfigure = ''
    sed -i docs/reference/ldmtool/Makefile.am \
      -e 's|-nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl|--nonet ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl|g'
  '';

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

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

  meta = with lib; {
    description = "Tool and library for managing Microsoft Windows Dynamic Disks";
    homepage = "https://github.com/mdbooth/libldm";
    maintainers = with maintainers; [ jensbin ];
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "ldmtool";
  };
}
