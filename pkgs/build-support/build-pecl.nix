{ stdenv, php, autoreconfHook, fetchurl }:

{ name
, buildInputs ? []
, nativeBuildInputs ? []
, makeFlags ? []
, src ? fetchurl {
    url = "http://pecl.php.net/get/${name}.tgz";
    inherit (args) sha256;
  }
, ...
}@args:

stdenv.mkDerivation (args // {
  name = "php-${name}";

  inherit src;

  nativeBuildInputs = [ autoreconfHook ] ++ nativeBuildInputs;
  buildInputs = [ php ] ++ buildInputs;

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ] ++ makeFlags;

  autoreconfPhase = "phpize";

  preConfigure = "touch unix.h";
})
