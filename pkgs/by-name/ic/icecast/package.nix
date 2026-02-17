{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  curl,
  libigloo,
  libkate,
  libopus,
  libtheora,
  libvorbis,
  libxml2,
  libxslt,
  rhash,
  speex,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icecast";
  version = "2.5.0";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/icecast/icecast-${finalAttrs.version}.tar.gz";
    hash = "sha256-2aoHx0Ka7BnZUP9v1CXDcfdxWM00/yIPwZGywYbGfHo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    libigloo
    libkate
    libopus
    libtheora
    libvorbis
    libxml2
    libxslt
    rhash
    speex
  ];

  passthru.tests = {
    inherit (nixosTests) icecast;
  };

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
})
