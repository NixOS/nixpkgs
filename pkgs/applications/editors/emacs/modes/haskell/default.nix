{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "haskell-mode-1.45";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.haskell.org/haskell-mode/haskell-mode-1.45.tar.gz;
    md5 = "c609998580cdb9ca8888c7d47d22ca3b";
  };
}
