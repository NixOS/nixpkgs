{ stdenv, fetchurl, libtoxcore
, conf ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "ratox-0.2.1";

  src = fetchurl {
    url = "nix-prefetch-url http://git.2f30.org/ratox/snapshot/${name}.tar.gz";
    sha256 = "1fm9b3clvnc2nf0pd1z8g08kfszwhk1ij1lyx57wl8vd51z4xsi5";
  };

  buildInputs = [ libtoxcore ];

  configFile = optionalString (conf!=null) (builtins.toFile "config.h" conf);
  preConfigure = optionalString (conf!=null) "cp ${configFile} config.def.h";

  preBuild = "makeFlags=PREFIX=$out";

  meta =
    { description = "FIFO based tox client";
      homepage = http://ratox.2f30.org/;
      license = licenses.isc;
      maintainers = with maintainers; [ emery ];
      platforms = platforms.linux;
    };
}
