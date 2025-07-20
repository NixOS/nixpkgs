{
  lib,
  stdenv,
  fetchurl,
  libogg,
  libvorbis,
  libao,
  pkg-config,
  curl,
  libiconv,
  speex,
  flac,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "vorbis-tools";
  version = "1.4.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/vorbis/vorbis-tools-${version}.tar.gz";
    hash = "sha256-of493Gd3vc6/a3l+ft/gQ3lUskdW/8yMa4FrY+BGDd4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libogg
    libvorbis
    libao
    curl
    speex
    flac
  ]
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
