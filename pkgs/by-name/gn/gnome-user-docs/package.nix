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

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-user-docs";
  version = "49.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${lib.versions.major finalAttrs.version}/gnome-user-docs-${finalAttrs.version}.tar.xz";
    hash = "sha256-BkRI6t1cHxW8j+tQQYpjRxFO+BXcjRXQCiDcX0iuioA=";
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
      packageName = "gnome-user-docs";
    };
  };

  meta = {
    description = "User and system administration help for the GNOME desktop";
    homepage = "https://help.gnome.org/users/gnome-help/";
    license = lib.licenses.cc-by-30;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.all;
  };
})
