{ stdenv, fetchurl, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "qpress-${version}";
  version = "11";

  src = fetchurl {
    url = "http://www.quicklz.com/qpress-${version}-linux-x64.tar";
    sha256 = "bf4d4201ce51ec902f06043f1a835056b106d88b901939c507353a00d8fd65dc";
  };

  builder = ./qpress-builder.sh;

  meta = {
    homepage = http://www.quicklz.com;
    description = "qpress file archiver";
  };
}

