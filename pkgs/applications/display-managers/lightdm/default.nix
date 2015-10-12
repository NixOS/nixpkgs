{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, xlibsWrapper, libxklavier, libgcrypt, libaudit
, qt4 ? null
, withQt5 ? false, qtbase
}:

let
  ver_branch = "1.16";
  version = "1.16.3";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "0jsvpg86nzwzacnr1bfzw81432j6m6lg2daqgy04ywj976k0x2y8";
  };

  patches = [ ./fix-paths.patch ];

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt
    qt4 libaudit
  ] ++ stdenv.lib.optional withQt5 qtbase;

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
  ] ++ stdenv.lib.optional (qt4 != null) "--enable-liblightdm-qt"
    ++ stdenv.lib.optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/lightdm;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
