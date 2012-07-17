{stdenv, fetchurl, readline, libssh, intltool}:

stdenv.mkDerivation rec {
  name = "yafc";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/downloads/sebastinas/yafc/${name}-${version}.tar.xz";
    sha256 = "0h5cbvvfkigvzfqqzvgqpn8m0ilyng3rgyh85c0mi48klzv8kb58";
  };

  buildInputs = [ readline libssh intltool ];

  meta = {
    description = "ftp/sftp client with readline, autocompletion and bookmarks";
    homepage = http://www.yafc-ftp.com;
    maintainers = [ "Carles Pagès <page@cubata.homelinux.net>" ];
    license = "GPLv2+";
  };
}
