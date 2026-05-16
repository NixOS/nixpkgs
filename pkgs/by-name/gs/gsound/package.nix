{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  vala,
  libcanberra,
  gobject-introspection,
  libtool,
  gnome,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "gsound";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gsound/${lib.versions.majorMinor version}/gsound-${version}.tar.xz";
    sha256 = "06l80xgykj7x1kqkjvcq06pwj2rmca458zvs053qc55x3sg06bfa";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gobject-introspection
    libtool
    vala
  ];
  buildInputs = [
    glib
    libcanberra
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gsound";
    description = "Small library for playing system sounds";
    mainProgram = "gsound-play";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
