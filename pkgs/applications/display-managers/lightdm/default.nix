{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, xlibsWrapper, libxklavier, libgcrypt, libaudit, gcc6
, qt4 ? null
, withQt5 ? false, qtbase
}:

with stdenv.lib;

let
  ver_branch = "1.22";
  version = "1.22.0";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "0a5bvfl2h7r873al6q7c819h0kg564k9fh51rl6489z6lyvazfg4";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [
    pam libxcb glib libXdmcp itstool libxml2 libxklavier libgcrypt
    qt4 libaudit gcc6
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
