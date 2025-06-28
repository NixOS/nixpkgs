{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gnome,
  itstool,
  libxml2,
  yelp-tools,
}:

stdenv.mkDerivation rec {
  pname = "gnome-user-docs";
  version = "48.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-Z4Kfdkumctf5n/cu9lE7QMyTH7QBv3vX21+AXnv6Pbk=";
  };

  nativeBuildInputs = [
    gettext
    itstool
    libxml2
    yelp-tools
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = with lib; {
    description = "User and system administration help for the GNOME desktop";
    homepage = "https://help.gnome.org/users/gnome-help/";
    license = licenses.cc-by-30;
    teams = [ teams.gnome ];
    platforms = platforms.all;
  };
}
