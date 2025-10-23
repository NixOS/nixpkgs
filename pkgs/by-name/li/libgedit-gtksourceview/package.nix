{
  stdenv,
  lib,
  fetchFromGitLab,
  docbook-xsl-nons,
  gobject-introspection,
  gtk-doc,
  meson,
  ninja,
  pkg-config,
  libxml2,
  glib,
  gtk3,
  shared-mime-info,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gtksourceview";
  version = "299.5.0";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "gedit";
    repo = "libgedit-gtksourceview";
    rev = finalAttrs.version;
    hash = "sha256-3HnlYLa1Zy1GRpX5fjEoXUzfB9X6nydpVjZTzJyhvIs=";
  };

  patches = [
    # By default, the library loads syntaxes from XDG_DATA_DIRS and user directory
    # but not from its own datadr (it assumes it will be in XDG_DATA_DIRS).
    # Since this is not generally true with Nix, let’s add $out/share unconditionally.
    ./nix-share-path.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxml2
  ];

  propagatedBuildInputs = [
    # Required by libgedit-gtksourceview-300.pc
    glib
    gtk3
    # Used by gtk_source_language_manager_guess_language
    shared-mime-info
  ];

  passthru.updateScript = gitUpdater { ignoredVersions = "(alpha|beta|rc).*"; };

  meta = with lib; {
    description = "Source code editing widget for GTK";
    homepage = "https://gitlab.gnome.org/World/gedit/libgedit-gtksourceview";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
  };
})
