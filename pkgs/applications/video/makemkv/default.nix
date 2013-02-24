{ stdenv, fetchurl
, openssl, qt4, mesa, zlib
}:

stdenv.mkDerivation rec {
  name = "makemkv-${ver}";
  ver = "1.8.0";
  builder = ./builder.sh;

  src_bin = fetchurl {
    url = "http://www.makemkv.com/download/makemkv-bin-${ver}.tar.gz";
    sha256 = "1f465rdv5ibnh5hnfmvmlid0yyzkansjw8l1mi5qd3bc6ca4k30c";
  };

  src_oss = fetchurl { 
    url = "http://www.makemkv.com/download/makemkv-oss-${ver}.tar.gz";
    sha256 = "0kj1mpkzz2cvi0ibdgdzfwbh9k2jfj3ra5m3hd7iyc5ng21v4sk3";
  };

  buildInputs = [openssl qt4 mesa zlib];

  libPath = stdenv.lib.makeLibraryPath [stdenv.gcc.gcc openssl mesa qt4 zlib ] 
          + ":" + stdenv.gcc.gcc + "/lib64";

  meta = {
    description = "software to convert blu-ray and dvd to mkv";
    license = "unfree";
    homepage = http://makemkv.com;
  };
}
