{ stdenv, fetchurl, automake, autoconf, libtool, pkgconfig, libzen, libmediainfo, zlib }:

stdenv.mkDerivation rec {
  version = "0.7.73";
  name = "mediainfo-${version}";
  src = fetchurl {
    url = "http://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.bz2";
    sha256 = "14mbiy1xhj4nlp7hnfqvi518xn1f718b2vbl8xkjqr2sqjdf5jm7";
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
    homepage = http://mediaarea.net/;
    license = stdenv.lib.licenses.bsd2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.devhell ];
  };
}
