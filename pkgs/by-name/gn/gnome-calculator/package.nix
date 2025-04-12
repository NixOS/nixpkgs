{
  stdenv,
  lib,
  appstream,
  meson,
  ninja,
  vala,
  gettext,
  itstool,
  fetchurl,
  pkg-config,
  libxml2,
  gtk4,
  glib,
  gtksourceview5,
  wrapGAppsHook4,
  gnome,
  mpfr,
  gmp,
  libsoup_3,
  libmpc,
  libadwaita,
  gsettings-desktop-schemas,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "gnome-calculator";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calculator/${lib.versions.major version}/gnome-calculator-${version}.tar.xz";
    hash = "sha256-3s2yMoO12+70CVG2nq99S4DAw4gN2wGGP58PFVT4mYs=";
  };

  nativeBuildInputs = [
    appstream
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    glib
    libxml2
    gtksourceview5
    mpfr
    gmp
    libgee
    gsettings-desktop-schemas
    libsoup_3
    libmpc
    libadwaita
  ];

  doCheck = true;

  preCheck = ''
    # Currency conversion test tries to store currency data in $HOME/.cache.
    export HOME=$TMPDIR
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-calculator";
    };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Calculator/";
    description = "Application that solves mathematical equations and is suitable as a default application in a Desktop environment";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
