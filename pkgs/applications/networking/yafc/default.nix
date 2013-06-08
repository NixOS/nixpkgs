{stdenv, fetchurl, readline, libssh, intltool}:

stdenv.mkDerivation rec {
  name = "yafc-1.2.3";
  src = fetchurl {
    url = "https://github.com/downloads/sebastinas/yafc/${name}.tar.xz";
    sha256 = "11h5r9ragfpil338kq981wxnifacflqfwgydhmy00b3fbdlnxzsi";
  };

  buildInputs = [ readline libssh intltool ];

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://www.yafc-ftp.com;
    maintainers = [ stdenv.lib.maintainers.page ];
    license = "GPLv2+";
  };
}
