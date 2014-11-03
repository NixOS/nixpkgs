{stdenv, fetchurl, readline, libssh, intltool, libbsd}:

stdenv.mkDerivation rec {
  name = "yafc-1.3.2";
  src = fetchurl {
    url = "http://www.yafc-ftp.com/upload/${name}.tar.xz";
    sha256 = "0rrhik00xynxg5s3ffqlyynvy8ssv8zfaixkpb77baxa274gnbd7";
  };

  buildInputs = [ readline libssh intltool libbsd ];

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://www.yafc-ftp.com;
    maintainers = [ stdenv.lib.maintainers.page ];
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
