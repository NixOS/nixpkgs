{stdenv, fetchurl, readline, libssh, intltool}:

stdenv.mkDerivation rec {
  name = "yafc-1.2.0";
  src = fetchurl {
    url = "https://github.com/downloads/sebastinas/yafc/${name}.tar.xz";
    sha256 = "0h5cbvvfkigvzfqqzvgqpn8m0ilyng3rgyh85c0mi48klzv8kb58";
  };

  buildInputs = [ readline libssh intltool ];

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://www.yafc-ftp.com;
    maintainers = [ stdenv.lib.maintainers.page ];
    license = "GPLv2+";
  };
}
