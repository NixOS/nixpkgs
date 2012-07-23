{
  stdenv, fetchurl, boost, mesa, glew, mysql, libass, libmpeg2, libmad,
  libjpeg, libsamplerate, libogg, libvorbis, libmodplug, curl, flac, libgcrypt,
  bzip2, libtiff, lzo, yajl, pkgconfig, fontconfig, fribidi, sqlite, libpng,
  pcre, libcdio, freetype, jasper, SDL, SDL_mixer, SDL_image, alsaLib, dbus,
  libbluray
}:

stdenv.mkDerivation {
  buildInputs = [
    boost mesa glew mysql libass libmpeg2 libmad libjpeg libsamplerate libogg
    libvorbis libmodplug curl flac libgcrypt bzip2 libtiff lzo yajl pkgconfig
    fontconfig fribidi sqlite libpng pcre libcdio freetype jasper SDL SDL_mixer
    SDL_image alsaLib dbus libbluray
  ];
  name = "xbmc-11.0";
  src = fetchurl {
    url = http://mirrors.xbmc.org/releases/source/xbmc-11.0.tar.gz;
    sha256 = "068bgg6h593xwwinyqy8wsn4hpz90ib59g0k5dpg4f31q48d7r8z";
  };
  configurePhase = ''
    ./configure || cat config.log
    exit 1
  '';
}
