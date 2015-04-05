{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, x11, libxklavier, libgcrypt
, qt4 ? null, qt5 ? null
}:

let
  ver_branch = "1.14";
  version = "1.14.0";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "0fkbzqncx34dhylrg5328fih7xywmsqj2p40smnx33nyf047jdgc";
  };

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt
    qt4 qt5
  ];

  configureFlags = [
    "--enable-liblightdm-gobject"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ stdenv.lib.optional (qt4 != null) "--enable-liblightdm-qt"
    ++ stdenv.lib.optional (qt5 != null) "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = with stdenv.lib; {
    homepage = http://launchpad.net/lightdm;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
