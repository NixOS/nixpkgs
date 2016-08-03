{stdenv, fetchurl, readline, libssh, intltool, libbsd, pkgconfig}:

stdenv.mkDerivation rec {
  name = "yafc-1.3.6";
  src = fetchurl {
    url = "http://www.yafc-ftp.com/downloads/${name}.tar.xz";
    sha256 = "0wvrljihliggysfnzczc0s74i3ab2c1kzjjs99iqk98nxmb2b8v3";
  };

  buildInputs = [ readline libssh intltool libbsd pkgconfig ];

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://www.yafc-ftp.com;
    maintainers = [ stdenv.lib.maintainers.page ];
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
