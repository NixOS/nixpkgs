{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  intltool,
  libtool,
  pkg-config,
  which,
  docbook_xml_dtd_45,
  docbook_xsl,
  gtkmm2,
  pangomm_2_42,
  libgig,
  libsndfile,
  libxslt,
  linuxsampler,
}:

let
  gtkmm2_with_pango242 = gtkmm2.override { pangomm = pangomm_2_42; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gigedit";
  version = "1.2.1";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/gigedit-${finalAttrs.version}.tar.bz2";
    hash = "sha256-pz+2gbVbPytuioXxNHQWE3Pml4r9JfwBIQcsbevWHkQ=";
  };

  preConfigure = "make -f Makefile.svn";

  nativeBuildInputs = [
    autoconf
    automake
    intltool
    libtool
    pkg-config
    which
  ];

  buildInputs = [
    docbook_xml_dtd_45
    docbook_xsl
    gtkmm2_with_pango242
    libgig
    libsndfile
    libxslt
    linuxsampler
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.linuxsampler.org";
    description = "Gigasampler file access library";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "gigedit";
  };
})
