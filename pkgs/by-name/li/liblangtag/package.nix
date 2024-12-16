{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
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
  version = "0.6.3";

  # Artifact tarball contains lt-localealias.h needed for darwin
  src = fetchurl {
    url = "https://bitbucket.org/tagoh/liblangtag/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-HxKiCgLsOo0i5U3tuLaDpDycFgvaG6M3vxBgYHrnM70=";
  };

  core_zip = fetchurl {
    # please update if an update is available
    url = "http://www.unicode.org/Public/cldr/37/core.zip";
    sha256 = "0myswkvvaxvrz9zwq4zh65sygfd9n72cd5rk4pwacqba4nxgb4xs";
  };

  language_subtag_registry = fetchurl {
    url = "http://www.iana.org/assignments/language-subtag-registry";
    sha256 = "0y9x5gra6jri4sk16f0dp69p06almnsl48rs85605f035kf539qm";
  };

  patches = [
    # Pull upstream fix for gcc-13 build compatibility
    (fetchpatch {
      name = "gcc-13-p1.patch";
      url = "https://bitbucket.org/tagoh/liblangtag/commits/0b6e9f4616a34146e7443c4e9a7197153645e40b/raw";
      hash = "sha256-69wJDVwDCP5OPHKoRn9WZNrvfCvmlX3SwtRmcpJHn2o=";
    })
    (fetchpatch {
      name = "gcc-13-p1.patch";
      url = "https://bitbucket.org/tagoh/liblangtag/commits/1497c4477d0fa0b7df1886951b953dd3cea54427/raw";
      hash = "sha256-k0Uaeg6YLxVze4fgf0kiyuiZJ5wh2Jq3h7cFPQPtwyo=";
    })
  ];

  postPatch = ''
    gtkdocize
    cp "${core_zip}" data/core.zip
    touch data/stamp-core-zip
    cp "${language_subtag_registry}" data/language-subtag-registry
  '';

  configureFlags = lib.optional (
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
