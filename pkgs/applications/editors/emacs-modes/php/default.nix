{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "php-mode-1.5.0";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/php-mode/${name}.tar.gz";
    sha256 = "1bffgg4rpiggxqc1hvjcby24sfyzj5728zg7r6f4v6a126a7kcfq";
  };

  builder = ./builder.sh;
}
