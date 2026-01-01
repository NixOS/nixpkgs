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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "libgsf";
  version = "1.14.54";
=======
stdenv.mkDerivation rec {
  pname = "libgsf";
  version = "1.14.53";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgsf";
<<<<<<< HEAD
    tag = "LIBGSF_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-jry6Ezzm3uEofIsJd97EzX+qoOjQEb3H1Y8o65nqmeo=";
=======
    rev = "LIBGSF_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-vC/6QEoV6FvFxQ0YlMkBbTmAtqbkvgZf+9BU8epi8yo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
=======
  doCheck = true;

  preCheck = ''
    patchShebangs ./tests/
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # checking pkg-config is at least version 0.9.0... ./configure: line 15213: no: command not found
  # configure: error: in `/build/libgsf-1.14.50':
  # configure: error: The pkg-config script could not be found or is too old.  Make sure it
  # is in your PATH or set the PKG_CONFIG environment variable to the full
  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

<<<<<<< HEAD
  doCheck = true;

  preCheck = ''
    patchShebangs ./tests/
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = finalAttrs.pname;
=======
  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      versionPolicy = "odd-unstable";
    };
  };

<<<<<<< HEAD
  meta = {
    description = "GNOME's Structured File Library";
    homepage = "https://gitlab.gnome.org/GNOME/libgsf";
    changelog = "https://gitlab.gnome.org/GNOME/libgsf/-/blob/${finalAttrs.src.tag}/ChangeLog";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ lovek323 ];
=======
  meta = with lib; {
    description = "GNOME's Structured File Library";
    homepage = "https://www.gnome.org/projects/libgsf";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ lovek323 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.unix;

    longDescription = ''
      Libgsf aims to provide an efficient extensible I/O abstraction for
      dealing with different structured file formats.
    '';
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
