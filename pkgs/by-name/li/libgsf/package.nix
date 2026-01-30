{
  fetchFromGitLab,
  lib,
  stdenv,
  autoreconfHook,
  gtk-doc,
  pkg-config,
  intltool,
  gettext,
  glib,
  libxml2,
  zlib,
  bzip2,
  perl,
  gdk-pixbuf,
  libiconv,
  libintl,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgsf";
  version = "1.14.55";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgsf";
    tag = "LIBGSF_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-lx/FgF4X0aLtUFRaX69gX9J7w9ZlO0A1xoVg9Fgvtfo=";
  };

  postPatch = ''
    # Fix cross-compilation
    substituteInPlace configure.ac \
      --replace "AC_PATH_PROG(PKG_CONFIG, pkg-config, no)" \
                "PKG_PROG_PKG_CONFIG"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gtk-doc
    pkg-config
    intltool
    libintl
  ];

  buildInputs = [
    gettext
    bzip2
    zlib
  ];

  nativeCheckInputs = [
    perl
  ];

  propagatedBuildInputs = [
    libxml2
    glib
    gdk-pixbuf
    libiconv
  ];

  # checking pkg-config is at least version 0.9.0... ./configure: line 15213: no: command not found
  # configure: error: in `/build/libgsf-1.14.50':
  # configure: error: The pkg-config script could not be found or is too old.  Make sure it
  # is in your PATH or set the PKG_CONFIG environment variable to the full
  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  doCheck = true;

  preCheck = ''
    patchShebangs ./tests/
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "GNOME's Structured File Library";
    homepage = "https://gitlab.gnome.org/GNOME/libgsf";
    changelog = "https://gitlab.gnome.org/GNOME/libgsf/-/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
})
