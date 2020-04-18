{ stdenv, lib, php, autoreconfHook, fetchurl, re2c }:

{ pname
, version
, internalDeps ? []
, buildInputs ? []
, nativeBuildInputs ? []
, postPhpize ? ""
, makeFlags ? []
, src ? fetchurl {
    url = "http://pecl.php.net/get/${pname}-${version}.tgz";
    inherit (args) sha256;
  }
, ...
}@args:

stdenv.mkDerivation (args // {
  name = "php-${pname}-${version}";

  inherit src;

  nativeBuildInputs = [ autoreconfHook re2c ] ++ nativeBuildInputs;
  buildInputs = [ php ] ++ buildInputs;

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ] ++ makeFlags;

  autoreconfPhase = ''
    phpize
    ${postPhpize}
    ${lib.concatMapStringsSep "\n"
      (dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}")
      internalDeps}
  '';
})
