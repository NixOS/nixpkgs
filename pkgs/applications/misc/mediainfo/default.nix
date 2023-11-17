{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, libzen, libmediainfo, zlib }:

stdenv.mkDerivation rec {
  pname = "mediainfo";
  version = "23.10";

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediainfo/${version}/mediainfo_${version}.tar.xz";
    hash = "sha256-t0OuJSHZ2Oi5pYUNfCop3jC6d321JzjQ37oXzARnduc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libzen libmediainfo zlib ];

  sourceRoot = "MediaInfo/Project/GNU/CLI";

  configureFlags = [ "--with-libmediainfo=${libmediainfo}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Supplies technical and tag information about a video or audio file";
    longDescription = ''
      MediaInfo is a convenient unified display of the most relevant technical
      and tag data for video and audio files.
    '';
    homepage = "https://mediaarea.net/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.devhell ];
    mainProgram = "mediainfo";
  };
}
