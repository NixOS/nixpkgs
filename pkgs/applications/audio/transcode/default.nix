{ stdenv, fetchurl, flac, lame, zlib, libjpeg, libvorbis, libtheora, libxml2
, lzo, libdvdread, pkgconfig, x264, libmpeg2, xvidcore }:

stdenv.mkDerivation rec {
  name = "transcode-1.1.7";
  src = fetchurl {
    url = "https://bitbucket.org/france/transcode-tcforge/downloads/${name}.tar.bz2";
    sha256 = "1e4e72d8e0dd62a80b8dd90699f5ca64c9b0cb37a5c9325c184166a9654f0a92";
  };

  buildInputs = [ flac lame zlib libjpeg libvorbis libtheora libxml2 lzo
                  libdvdread pkgconfig x264 libmpeg2 xvidcore ];
  configureFlags = [
    "--disable-ffmpeg" "--disable-libavcodec" "--disable-libavformat"
    "--enable-lzo" "--enable-ogg" "--enable-vorbis" "--enable-theora" "--enable-libxml2"
    "--enable-x264" "--enable-libmpeg2" "--enable-xvid"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Suite of command line utilities for transcoding video and audio codecs, and for converting between different container formats";
    homepage = http://www.transcoding.org/;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
