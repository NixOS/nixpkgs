{ stdenv, fetchurl, libpng, libjpeg, bzip2, zlib, libtiff,  gpm, openssl, pkgconfig, directfb 
, enableX11 ? true, libX11, libXau, xproto, libXt }:

let
  version="2.2";
  name="links2-2.2";
  hash="188y37rw4s9brl55ncc12q1b45w0caxcnsq1gqyby9byw1sawnq9";
  url="http://links.twibright.com/download/links-${version}.tar.gz";
  advertisedUrl="http://links.twibright.com/download/links-2.2.tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    inherit url;
    sha256 = hash;
  };

  buildInputs = [ libpng libjpeg bzip2 zlib libtiff  gpm openssl pkgconfig directfb ]
    ++ stdenv.lib.optionals enableX11 [ libX11 libXau xproto libXt ];

  configureFlags = [
    "--enable-graphics"
    "--with-ssl"
    "--with-fb"
    ] ++ stdenv.lib.optional enableX11 "--with-x";

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  meta = {
    description = "A small browser with some graphics support";
    maintainers = [
      stdenv.lib.maintainers.viric
    ];
  };
}
