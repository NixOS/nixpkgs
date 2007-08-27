{stdenv, fetchurl, libX11, libXext, libXi, libXmu
, SDL, SDL_mixer, GStreamer
, libogg, libxml2, libjpeg, mesa, libpng}:

stdenv.mkDerivation {
  name = "gnash-0.7.2";

  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://gnu/gnash/0.7.2/gnash-0.7.2.tar.bz2;
    md5 = "ccef0f45be01a4c2992b46c2363a514f";
  };

  buildInputs = [libX11 libXext libXi libXmu SDL SDL_mixer GStreamer
                 libogg libxml2 libjpeg mesa libpng];
  inherit SDL_mixer SDL;
} // {mozillaPlugin = "/plugins";}
