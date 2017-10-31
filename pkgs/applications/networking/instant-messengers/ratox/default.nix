{ stdenv, fetchurl, libtoxcore
, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ratox-0.2.1";

  src = fetchurl {
    url = "http://git.2f30.org/ratox/snapshot/${name}.tar.gz";
    sha256 = "0xnw3zcz9frmcxqhwg38hhnsy1g5xl9yc19nl0vwi5awz8wqqy19";
  };

  buildInputs = [ libtoxcore ];

  configFile = optionalString (conf!=null) (builtins.toFile "config.h" conf);
  preConfigure = optionalString (conf!=null) "cp ${configFile} config.def.h";

  preBuild = "makeFlags=PREFIX=$out";

  meta =
    { description = "FIFO based tox client";
      homepage = http://ratox.2f30.org/;
      license = licenses.isc;
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.linux;
    };
}
