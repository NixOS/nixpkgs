{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, xlibsWrapper, libxklavier, libgcrypt, libaudit
, qt4 ? null
, withQt5 ? false, qtbase
}:

with stdenv.lib;

let
  ver_branch = "1.24";
  version = "1.24.0";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "18j33bm54i8k7ncxcs69zqi4105s62n58jrydqn3ikrb71s9nl6d";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [
    pam libxcb glib libXdmcp itstool libxml2 libxklavier libgcrypt
    qt4 libaudit
  ] ++ optional withQt5 qtbase;

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
  ] ++ optional (qt4 != null) "--enable-liblightdm-qt"
    ++ optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    homepage = https://launchpad.net/lightdm;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
