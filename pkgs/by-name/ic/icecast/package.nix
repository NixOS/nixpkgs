{
  lib,
  stdenv,
  fetchurl,
  libxml2,
  libxslt,
  curl,
  libvorbis,
  libtheora,
  speex,
  libkate,
  libopus,
}:

stdenv.mkDerivation rec {
  pname = "icecast";
  version = "2.4.4";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/icecast/icecast-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildInputs = [
    libxml2
    libxslt
    curl
    libvorbis
    libtheora
    speex
    libkate
    libopus
  ];

  hardeningEnable = [ "pie" ];

  meta = {
    description = "Server software for streaming multimedia";
    mainProgram = "icecast";

    longDescription = ''
      Icecast is a streaming media server which currently supports
      Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams.
      It can be used to create an Internet radio station or a privately
      running jukebox and many things in between. It is very versatile
      in that new formats can be added relatively easily and supports
      open standards for commuincation and interaction.
    '';

    homepage = "https://www.icecast.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jcumming ];
    platforms = with lib.platforms; unix;
  };
}
