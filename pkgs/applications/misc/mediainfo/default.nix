{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, libmediainfo, zlib }:

let version = "0.7.71"; in

stdenv.mkDerivation {
  name = "mediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.bz2";
    sha256 = "0sf0ym0v5ds5w4bxk66712adybr1prxxqwvrf9clm57ibs602jfq";
  };

  buildInputs = [ automake autoconf libtool pkgconfig libzen libmediainfo zlib ];

  sourceRoot = "./MediaInfo/Project/GNU/CLI/";

  configureFlags = [ "--with-libmediainfo=${libmediainfo}" ];
  preConfigure = "sh autogen";

  meta = {
    description = "Supplies technical and tag information about a video or audio file";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = http://mediaarena.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
