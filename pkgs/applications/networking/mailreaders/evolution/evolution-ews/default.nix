{ lib, stdenv, fetchurl, gnome3, cmake, gettext, intltool, pkg-config, evolution-data-server, evolution
, sqlite, gtk3, webkitgtk, libgdata, libmspack }:

stdenv.mkDerivation rec {
  pname = "evolution-ews";
  version = "3.38.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1s2jpviliazmhnpkh8dc57ga3c3612f2rnc0nfya5ndbi6lpzxhi";
  };

  nativeBuildInputs = [ cmake gettext intltool pkg-config ];

  buildInputs = [
    evolution-data-server evolution
    sqlite libgdata
    gtk3 webkitgtk
    libmspack
  ];

  # Building with libmspack as reccommended: https://wiki.gnome.org/Apps/Evolution/Building#Build_evolution-ews
  cmakeFlags = [
    "-DWITH_MSPACK=ON"
  ];

  PKG_CONFIG_EVOLUTION_SHELL_3_0_ERRORDIR = "${placeholder "out"}/share/evolution/errors";
  PKG_CONFIG_EVOLUTION_SHELL_3_0_PRIVLIBDIR = "${placeholder "out"}/lib/evolution";
  PKG_CONFIG_CAMEL_1_2_CAMEL_PROVIDERDIR = "${placeholder "out"}/lib/evolution-data-server/camel-providers";
  PKG_CONFIG_LIBEDATA_BOOK_1_2_BACKENDDIR = "${placeholder "out"}/lib/evolution-data-server/addressbook-backends";
  PKG_CONFIG_LIBEDATA_CAL_2_0_BACKENDDIR = "${placeholder "out"}/lib/evolution-data-server/calendar-backends";
  PKG_CONFIG_LIBEBACKEND_1_2_MODULEDIR = "${placeholder "out"}/lib/evolution-data-server/registry-modules";
  PKG_CONFIG_EVOLUTION_SHELL_3_0_MODULEDIR = "${placeholder "out"}/lib/evolution/modules";
  PKG_CONFIG_EVOLUTION_DATA_SERVER_1_2_PRIVDATADIR = "${placeholder "out"}/share/evolution-data-server";

   passthru = {
    updateScript = gnome3.updateScript {
      packageName = "evolution-ews";
    };
  };

  meta = with lib; {
    description = "Evolution connector for Microsoft Exchange Server protocols";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-ews";
    license = "LGPL-2.1-only OR LGPL-3.0-only"; # https://gitlab.gnome.org/GNOME/evolution-ews/issues/111
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
