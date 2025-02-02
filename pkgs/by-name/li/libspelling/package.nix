{
  lib,
  stdenv,
  fetchFromGitLab,
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

stdenv.mkDerivation rec {
  pname = "libspelling";
  version = "0.4.5";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libspelling";
    rev = version;
    hash = "sha256-+WjhBg98s5RxQfd85FtMNuoVWjw9Hap9yDqnpYNAGgw=";
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
    glib
    gtk4
    gtksourceview5
    enchant
    icu
    libsysprof-capture
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
    maintainers = with maintainers; [ chuangzhu ] ++ teams.gnome.members;
  };
}
