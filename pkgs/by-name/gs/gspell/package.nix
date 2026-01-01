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
  enchant2,
  gnome,
}:

stdenv.mkDerivation rec {
  pname = "gspell";
<<<<<<< HEAD
  version = "1.14.2";
=======
  version = "1.14.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
<<<<<<< HEAD
    sha256 = "TsflrMyQEygbrNa7wAAGvnM4GLgbo/4zLB6HbH4eFHc=";
=======
    sha256 = "ZOodjp7cHCW0WpIOgNr2dVnRhm/81/hDL+z+ptD+iJc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    enchant2
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

<<<<<<< HEAD
  meta = {
    description = "Spell-checking library for GTK applications";
    mainProgram = "gspell-app1";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Spell-checking library for GTK applications";
    mainProgram = "gspell-app1";
    homepage = "https://gitlab.gnome.org/GNOME/gspell";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
