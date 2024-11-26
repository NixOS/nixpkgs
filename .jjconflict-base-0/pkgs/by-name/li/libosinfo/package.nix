{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  meson,
  ninja,
  gettext,
  gobject-introspection,
  gtk-doc,
  docbook_xsl,
  glib,
  libsoup_3,
  libxml2,
  libxslt,
  check,
  curl,
  perl,
  hwdata,
  osinfo-db,
  substituteAll,
  vala ? null,
}:

stdenv.mkDerivation rec {
  pname = "libosinfo";
  version = "1.11.0";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-G/lu7J4UYPPRpxMWPMof8NSAo0kLUImSkvFFSLOpa2A=";
  };

  outputs = [
    "out"
    "dev"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "devdoc";

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    gettext
    gobject-introspection
    gtk-doc
    docbook_xsl
    perl # for pod2man
  ];
  buildInputs = [
    glib
    libsoup_3
    libxml2
    libxslt
  ];
  nativeCheckInputs = [
    check
    curl
    perl
  ];

  patches = [
    (substituteAll {
      src = ./osinfo-db-data-dir.patch;
      osinfo_db_data_dir = "${osinfo-db}/share";
    })

    # Fix build with libxml 2.12
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/libosinfo/-/commit/5bbdd06503456784c5ffa22409e8bab50470d673.patch";
      hash = "sha256-KqgHXI+lD5VYp2wtA58Drp15TgNK1O3xCaYBy4/B9wc=";
    })
  ];

  mesonFlags = [
    "-Dwith-usb-ids-path=${hwdata}/share/hwdata/usb.ids"
    "-Dwith-pci-ids-path=${hwdata}/share/hwdata/pci.ids"
    "-Denable-gtk-doc=true"
  ];

  preCheck = ''
    patchShebangs ../osinfo/check-symfile.pl ../osinfo/check-symsorting.pl
  '';

  doCheck = true;

  meta = with lib; {
    description = "GObject based library API for managing information about operating systems, hypervisors and the (virtual) hardware devices they can support";
    homepage = "https://libosinfo.org/";
    changelog = "https://gitlab.com/libosinfo/libosinfo/-/blob/v${version}/NEWS";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
