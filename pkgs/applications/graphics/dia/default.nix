{ stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, perlPackages
, glib
, gtk2
, libxml2
, python2
, docbook_xml_dtd_45
, docbook-xsl-nons
, libxslt
, gettext
, python3
, desktop-file-utils
, zlib
, cairo
, gtk-mac-integration-gtk2
}:

stdenv.mkDerivation {
  pname = "dia";
  version = "unstable-2020-04-07";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "dia";
    rev = "475bceff3f445f3fe691593a3003527a0d8bf0d9";
    sha256 = "mxP2FJl77SEURO6AUlLusMLHW0EeBw4hI5gw7egt3HE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    python3 # for install script
    gtk2 # for gtk-update-icon-cache
    libxslt # for xsltproc
    desktop-file-utils
    docbook_xml_dtd_45
    docbook-xsl-nons
  ];

  buildInputs = [
    glib
    gtk2
    libxml2
    python2
    zlib
    cairo
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    gtk-mac-integration-gtk2
  ];

  postPatch = ''
    patchShebangs \
      generate_run_with_dia_env.sh \
      build-aux/post-install.py
  '';

  meta = with stdenv.lib; {
    description = "GNOME Diagram drawing software";
    homepage = "https://wiki.gnome.org/Apps/Dia";
    maintainers = with maintainers; [ raskin ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
