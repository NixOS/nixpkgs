{ stdenv, php, autoreconfHook }:

args@{ name, ... }: stdenv.mkDerivation (args // {
  name = "php-${name}";

  buildInputs = [ php autoreconfHook ] ++ args.buildInputs or [];

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ] ++ args.makeFlags or [];

  autoreconfPhase = "phpize";
})
