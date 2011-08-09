{stdenv}: {pathname, md5}: stdenv.mkDerivation {
  name = baseNameOf (toString pathname);
  builder = ./builder.sh;
  pathname = pathname;
  md5 = md5;
  id = md5;
}
