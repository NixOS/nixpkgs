{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "nxml-mode-20031031";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.thaiopensource.com/download/nxml-mode-20031031.tar.gz;
    md5 = "4cbc32047183e6cc1b7a2757d1078bd2";
  };
}
