{stdenv}: {pathname, md5}: stdenv.mkDerivation {
  name = baseNameOf (toString url);
  builder = ./builder.sh;
  pathname = pathname;
  md5 = md5;
  id = md5;
}
