{stdenv}:

args:

stdenv.mkDerivation ({
  name = if args ? name then args.name else baseNameOf (toString args.src);
  builder = ./generic-substituter.sh;
  substitute = ./substitute.sh;
  inherit (args) src;
} // args)
