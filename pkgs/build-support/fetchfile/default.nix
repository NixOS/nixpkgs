{stdenv}: {pathname, md5}: derivation {
  name = baseNameOf (toString url);
  system = stdenv.system;
  builder = ./builder.sh;
  stdenv = stdenv;
  pathname = pathname;
  md5 = md5;
  id = md5;
}
