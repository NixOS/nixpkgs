{ stdenv, fetchFromGitHub, pam, pkgconfig, autoconf, automake, libtool, libxcb
, glib, libXdmcp, itstool, intltool, libxklavier, libgcrypt, audit, busybox
, polkit, accountsservice, gtk-doc, gnome3, gobjectIntrospection, vala
, withQt4 ? false, qt4
, withQt5 ? false, qtbase
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "lightdm";
  version = "1.26.0";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = version;
    sha256 = "1mhj6l025cnf2dzxnbzlk0qa9fm4gj2aw58qh5fl4ky87dp4wdyb";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gnome3.yelp-tools
    gnome3.yelp-xsl
    gobjectIntrospection
    gtk-doc
    intltool
    itstool
    libtool
    pkgconfig
    vala
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    libgcrypt
    libxcb
    libXdmcp
    libxklavier
    pam
    polkit
  ] ++ optional withQt4 qt4
    ++ optional withQt5 qtbase;


  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-static"
  ] ++ optional withQt4 "--enable-liblightdm-qt"
    ++ optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  prePatch = ''
    substituteInPlace autogen.sh \
      --replace "which" "${busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace /bin/rm ${busybox}/bin/rm
  '';

  meta = {
    homepage = https://github.com/CanonicalLtd/lightdm;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington worldofpeace ];
  };
}
