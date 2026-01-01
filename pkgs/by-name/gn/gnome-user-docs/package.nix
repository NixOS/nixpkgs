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
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${lib.versions.major version}/${pname}-${version}.tar.xz";
    hash = "sha256-DlC4u0/OqpEoNnzTRY5e24YclieMGqmnOm7AQCt7xhc=";
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

<<<<<<< HEAD
  meta = {
    description = "User and system administration help for the GNOME desktop";
    homepage = "https://help.gnome.org/users/gnome-help/";
    license = lib.licenses.cc-by-30;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "User and system administration help for the GNOME desktop";
    homepage = "https://help.gnome.org/users/gnome-help/";
    license = licenses.cc-by-30;
    teams = [ teams.gnome ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
