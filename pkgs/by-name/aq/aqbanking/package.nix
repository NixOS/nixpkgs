{
  lib,
  stdenv,
  fetchurl,
  gmp,
  gwenhywfar,
  libtool,
  libxml2,
  libxslt,
  pkg-config,
  gettext,
  xmlsec,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "aqbanking";
  version = "6.9.1";
  releaseId = "652";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/${releaseId}/aqbanking-${version}.tar.gz";
    hash = "sha256-/JSivr+7T8JrmNyTyPo2qAJimM15lfeYIcSA2zVYf2s=";
  };

  # Set the include dir explicitly, this fixes a build error when building
  # kmymoney because otherwise the includedir is overwritten by gwenhywfar's
  # cmake file
  postPatch = ''
    sed -i '/^set_and_check(AQBANKING_INCLUDE_DIRS "@aqbanking_headerdir@")/i set_and_check(includedir "@includedir@")' aqbanking-config.cmake.in
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [
    gmp
    gwenhywfar
    libtool
    libxml2
    libxslt
    xmlsec
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  meta = {
    description = "Interface to banking tasks, file formats and country information";
    homepage = "https://www.aquamaniac.de/rdm/";
    hydraPlatforms = [ ];
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
