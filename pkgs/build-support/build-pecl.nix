{ stdenv, php, autoreconfHook }:

args: stdenv.mkDerivation (args // {
  buildInputs = [ php autoreconfHook ] ++ args.buildInputs or [];

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ] ++ args.makeFlags or [];

  autoreconfPhase = "phpize";
})
