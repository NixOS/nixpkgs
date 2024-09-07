{ stdenv
, lib
, fetchFromGitHub
, docbook-xsl-nons
, gobject-introspection
, gtk-doc
, meson
, ninja
, pkg-config
, libxml2
, glib
, gtk3
, shared-mime-info
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgedit-gtksourceview";
  version = "299.2.1";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitHub {
    owner = "gedit-technology";
    repo = "libgedit-gtksourceview";
    rev = finalAttrs.version;
    hash = "sha256-fmYIZvsB3opstpPEd9vahcD9yUZKPBpSIrlNDs+eCdw=";
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

  passthru.updateScript = gitUpdater {
    odd-unstable = true;
  };

  meta = with lib; {
    description = "Source code editing widget for GTK";
    homepage = "https://github.com/gedit-technology/libgedit-gtksourceview";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.linux;
  };
})
