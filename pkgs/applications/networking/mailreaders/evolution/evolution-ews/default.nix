{ stdenv
, lib
, fetchurl
, gnome
, cmake
, gettext
, intltool
, pkg-config
, evolution-data-server
, evolution
, gtk3
, libsoup_3
, libical
, json-glib
, libmspack
, webkitgtk_4_1
}:

stdenv.mkDerivation rec {
  pname = "evolution-ews";
  version = "3.45.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "YAykQOupPvfqKID4mFhzxZgKSE7VKgVuNr09mEU+QBc=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    intltool
    pkg-config
  ];

  buildInputs = [
    evolution-data-server
    evolution
    gtk3
    libsoup_3
    libical
    json-glib
    libmspack
    # For evolution-shell-3.0
    webkitgtk_4_1
  ];

  cmakeFlags = [
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
