{stdenv, fetchurl, libX11, libXext, libXi, libXmu
, SDL, SDL_mixer, GStreamer
, libogg, libxml2, libjpeg, mesa, libpng}:

stdenv.mkDerivation {
  name = "gnash-0.7.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/gnu/gnash/0.7.1/gnash-0.7.1.tar.bz2;
    md5 = "d860981aeaac0fc941a28abc3c24223c";
  };

  buildInputs = [libX11 libXext libXi libXmu SDL SDL_mixer GStreamer
                 libogg libxml2 libjpeg mesa libpng];
  inherit SDL_mixer SDL;
}
