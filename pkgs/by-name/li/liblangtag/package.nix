{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  autoconf-archive,
  gtk-doc,
  gettext,
  pkg-config,
  glib,
  libxml2,
  gobject-introspection,
  gnome-common,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "liblangtag";
  version = "0.6.8";

  # Artifact tarball contains lt-localealias.h needed for darwin
  src = fetchurl {
    url = "https://gitlab.com/tagoh/liblangtag/-/releases/${version}/downloads/liblangtag-${version}.tar.bz2";
    hash = "sha256-qWl1t53dj+9tkpXAg/4/GvoaiJilcjXUBpJVreROXPI=";
  };

  core_zip = fetchurl {
    # please update if an update is available
    url = "http://www.unicode.org/Public/cldr/48/core.zip";
    hash = "sha256-BsfGmNb9jWfO+sFaAgawEJsA4O8WNvhvhESfqVlWH3Q=";
  };

  language_subtag_registry = fetchurl {
    url = "https://web.archive.org/web/20241120202537id_/https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry";
    hash = "sha256-xy94jbBKP0Ig7yOPutSviCA6uryx7PW2b1lBIPk2+6Q=";
  };

  postPatch = ''
    gtkdocize
    cp "${core_zip}" data/core.zip
    touch data/stamp-core-zip
    cp "${language_subtag_registry}" data/language-subtag-registry
  '';

  configureFlags = [
    "ac_cv_va_copy=1"
  ]
  ++ lib.optional (
    stdenv.hostPlatform.libc == "glibc"
  ) "--with-locale-alias=${stdenv.cc.libc}/share/locale/locale.alias";

  buildInputs = [
    gettext
    glib
    libxml2
    gnome-common
  ];
  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    gtk-doc
    gettext
    pkg-config
    unzip
    gobject-introspection
  ];

  meta = {
    changelog = "https://gitlab.com/tagoh/liblangtag/-/blob/${version}/NEWS";
    description = "Interface library to access tags for identifying languages";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "https://gitlab.com/tagoh/liblangtag";
  };
}
