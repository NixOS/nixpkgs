{stdenv, nix}: {pathname, md5}: stdenv.mkDerivation {
  name = baseNameOf (toString pathname);
  buildInputs = [ nix ];
  builder = ./builder.sh;
  pathname = pathname;
  md5 = md5;
  id = md5;
}
