{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gnome,
  itstool,
  libxml2,
  meson,
  ninja,
  yelp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-user-docs";
  version = "51.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-user-docs/${lib.versions.major finalAttrs.version}/gnome-user-docs-${finalAttrs.version}.tar.xz";
    hash = "sha256-rXb0QIkQ/th/39sLJMYFaK2nFkXr6Rl8q+KzpSHlrWQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    itstool
    libxml2
    meson
    ninja
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
