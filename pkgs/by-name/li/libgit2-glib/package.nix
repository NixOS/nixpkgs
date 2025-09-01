{
  stdenv,
  lib,
  fetchurl,
  gnome,
  meson,
  ninja,
  pkg-config,
  vala,
  libssh2,
  gtk-doc,
  gobject-introspection,
  gi-docgen,
  libgit2,
  glib,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgit2-glib";
  version = "1.2.1";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libgit2-glib/${lib.versions.majorMinor finalAttrs.version}/libgit2-glib-${finalAttrs.version}.tar.xz";
    sha256 = "l0I6d5ACs76HUcdfnXkEnfzMo2FqJhWfwWJIZ3K6eF8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gtk-doc
    gobject-introspection
    gi-docgen
  ];

  propagatedBuildInputs = [
    # Required by libgit2-glib-1.0.pc
    libgit2
    glib
  ];

  buildInputs = [
    libssh2
    python3.pkgs.pygobject3 # this should really be a propagated input of python output
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
  ];

  postPatch = ''
    chmod +x meson_python_compile.py
    patchShebangs meson_python_compile.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "libgit2-glib";
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Glib wrapper library around the libgit2 git access library";
    homepage = "https://gitlab.gnome.org/GNOME/libgit2-glib";
    license = licenses.lgpl21Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})
