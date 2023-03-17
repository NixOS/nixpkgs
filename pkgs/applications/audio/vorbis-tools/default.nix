{ lib, stdenv, fetchurl, libogg, libvorbis, libao, pkg-config, curl
, speex, flac
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "vorbis-tools";
  version = "1.4.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/vorbis-tools-${version}.tar.gz";
    sha256 = "1c7h4ivgfdyygz2hyh6nfibxlkz8kdk868a576qkkjgj5gn78xyv";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libogg libvorbis libao curl speex flac ];

  meta = with lib; {
    description = "Extra tools for Ogg-Vorbis audio codec";
    longDescription = ''
      A set of command-line tools to manipulate Ogg Vorbis audio
      files, notably the `ogg123' player and the `oggenc' encoder.
    '';
    homepage = "https://xiph.org/vorbis/";
    license = licenses.gpl2;
    platforms = platforms.all;
  };
}

