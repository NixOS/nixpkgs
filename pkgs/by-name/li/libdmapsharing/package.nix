{
  stdenv,
  lib,
  fetchFromGitLab,
  autoconf,
  automake,
  libtool,
  pkg-config,
  vala,
  avahi,
  gdk-pixbuf,
  gst_all_1,
  glib,
  gtk-doc,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gobject-introspection,
  libsoup_3,
  withGtkDoc ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation rec {
  pname = "libdmapsharing";
  version = "3.9.13";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withGtkDoc [
    "devdoc"
  ];

  outputBin = "dev";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libdmapsharing";
    rev = "${lib.toUpper pname}_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "oR9lpOFxgGfrtzncFT6dbmhKQfcuH/NvhOR/USHAHQc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    gtk-doc # gtkdocize
    pkg-config
    gobject-introspection
    vala
  ]
  ++ lib.optionals withGtkDoc [
    docbook-xsl-nons
    docbook_xml_dtd_43
  ];

  buildInputs = [
    avahi
    gdk-pixbuf
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ]
  ++ lib.optionals withGtkDoc [
    gtk-doc
  ];

  propagatedBuildInputs = [
    glib
    libsoup_3
  ];

  configureFlags = [
    (lib.enableFeature false "tests") # Tests require mDNS server
    (lib.enableFeature withGtkDoc "gtk-doc")
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail pkg-config "$PKG_CONFIG"
  '';

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://www.flyn.org/projects/libdmapsharing/";
    description = "Library that implements the DMAP family of protocols";
    teams = [ teams.gnome ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
