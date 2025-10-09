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
  version = "0.6.7";

  # Artifact tarball contains lt-localealias.h needed for darwin
  src = fetchurl {
    url = "https://bitbucket.org/tagoh/liblangtag/downloads/${pname}-${version}.tar.bz2";
    hash = "sha256-Xta81K4/PAXJEuYvIWzRpEEjhGFH9ymkn7VmjaUeAw4=";
  };

  core_zip = fetchurl {
    # please update if an update is available
    url = "http://www.unicode.org/Public/cldr/46/core.zip";
    hash = "sha256-+86cInWGKtJmaPs0eD/mwznz2S3f61oQoXdftYGBoV0=";
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

  meta = with lib; {
    description = "Interface library to access tags for identifying languages";
    license = licenses.mpl20;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    # There are links to a homepage that are broken by a BitBucket change
    homepage = "https://bitbucket.org/tagoh/liblangtag/overview";
  };
}
