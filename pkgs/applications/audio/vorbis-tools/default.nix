{ lib, stdenv, fetchurl, fetchpatch, libogg, libvorbis, libao, pkg-config, curl, libiconv
, speex, flac
, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "vorbis-tools";
  version = "1.4.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/vorbis-tools-${version}.tar.gz";
    sha256 = "1c7h4ivgfdyygz2hyh6nfibxlkz8kdk868a576qkkjgj5gn78xyv";
  };

  patches = lib.optionals stdenv.cc.isClang [
    # Fixes a call to undeclared function `utf8_decode`.
    # https://github.com/xiph/vorbis-tools/pull/33
    (fetchpatch {
      url = "https://github.com/xiph/vorbis-tools/commit/8a645f78b45ae7e370c0dc2a52d0f2612aa6110b.patch";
      hash = "sha256-RkT9Xa0pRu/oO9E9qhDa17L0luWgYHI2yINIkPZanmI=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libogg libvorbis libao curl speex flac ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

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

