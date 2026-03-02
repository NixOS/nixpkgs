{
  stdenv,
  lib,
  fetchurl,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  vala,
  mesonEmulatorHook,
  gtk3,
  icu,
  enchant,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gspell";
  version = "1.14.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/gspell/${lib.versions.majorMinor version}/gspell-${version}.tar.xz";
    sha256 = "TsflrMyQEygbrNa7wAAGvnM4GLgbo/4zLB6HbH4eFHc=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    glib # glib-mkenums
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk3
    icu
  ];

  propagatedBuildInputs = [
    # required for pkg-config
    enchant
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = {
    description = "Spell-checking library for GTK applications";
    mainProgram = "gspell-app1";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
}
