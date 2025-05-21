{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  gi-docgen,
  glib,
  gtk4,
  gtksourceview5,
  enchant,
  icu,
  libsysprof-capture,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libspelling";
  version = "0.4.8";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libspelling/${lib.versions.majorMinor finalAttrs.version}/libspelling-${finalAttrs.version}.tar.xz";
    hash = "sha256-J3ZGKFgY2nspXvAHssXr2BXQkws60JdQWzztlpZa9Rc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gi-docgen
  ];

  buildInputs = [
    enchant
    icu
    libsysprof-capture
  ];

  propagatedBuildInputs = [
    # These were moved from buildInputs because they are
    # listed in `Requires` key of `libspelling-1.pc`
    glib
    gtk4
    gtksourceview5
  ];

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "libspelling";
  };

  meta = with lib; {
    description = "Spellcheck library for GTK 4";
    homepage = "https://gitlab.gnome.org/GNOME/libspelling";
    license = licenses.lgpl21Plus;
    changelog = "https://gitlab.gnome.org/GNOME/libspelling/-/raw/${version}/NEWS";
    maintainers = with maintainers; [ chuangzhu ];
    teams = [ teams.gnome ];
  };
})
