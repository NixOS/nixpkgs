{ lib, stdenv, fetchurl, gnome, cmake, gettext, intltool, pkg-config, evolution-data-server, evolution
, sqlite, gtk3, webkitgtk, libgdata, libmspack }:

stdenv.mkDerivation rec {
  pname = "evolution-ews";
  version = "3.44.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "xXPzlxA8FybyS+Tz+f0gzrvJtEW6CysOt8lI/YQVBho=";
  };

  nativeBuildInputs = [ cmake gettext intltool pkg-config ];

  buildInputs = [
    evolution-data-server evolution
    sqlite libgdata
    gtk3 webkitgtk
    libmspack
  ];

  cmakeFlags = [
    # Building with libmspack as recommended: https://wiki.gnome.org/Apps/Evolution/Building#Build_evolution-ews
    "-DWITH_MSPACK=ON"
    # don't try to install into ${evolution}
    "-DFORCE_INSTALL_PREFIX=ON"
  ];

   passthru = {
    updateScript = gnome.updateScript {
      packageName = "evolution-ews";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Evolution connector for Microsoft Exchange Server protocols";
    homepage = "https://gitlab.gnome.org/GNOME/evolution-ews";
    license = licenses.lgpl21Plus; # https://gitlab.gnome.org/GNOME/evolution-ews/issues/111
    maintainers = [ maintainers.dasj19 ];
    platforms = platforms.linux;
  };
}
