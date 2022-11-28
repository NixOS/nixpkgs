{ curl
, dbus
, fdk_aac
, fetchurl
, flac
, fltk
, lame
, lib
, libopus
, libsamplerate
, libshout
, pkg-config
, portaudio
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "butt";
  version = "0.1.36";

  src = fetchurl {
    url = "mirror://sourceforge/butt/${pname}-${version}.tar.gz";
    sha256 = "1jg7662v88k432cb5dsn0hmbrn517whqw4dv113zp24q1c2kksmm";
  };

  buildInputs = [
    curl
    dbus
    fdk_aac
    flac
    fltk
    lame
    libopus
    libsamplerate
    libshout
    portaudio
  ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;

  meta = with lib; {
    description = "Source client for icecast";
    longDescription = ''
      butt (broadcast using this tool) is an easy to use, multi OS streaming
      tool. It supports ShoutCast and IceCast and runs on Linux, MacOS and
      Windows. The main purpose of butt is to stream live audio data from your
      computer's mic or line input to a Shoutcast or Icecast server. Recording
      is also possible. It is NOT intended to be a server by itself or
      automatically stream a set of audio files.
    '';
    homepage = "https://danielnoethen.de/butt/";
    license = licenses.gpl2;
    maintainers = [ maintainers.ddelabru ];
    platforms = platforms.linux;
  };
}
