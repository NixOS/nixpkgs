{ lib, stdenv, fetchFromGitHub, autoreconfHook,
  fltk, jansson, rtmidi, libsamplerate, libsndfile,
  jack2, alsaLib, libpulseaudio,
  libXpm, libXinerama, libXcursor }:

stdenv.mkDerivation rec {
  pname = "giada";
  version = "0.15.4";

  src = fetchFromGitHub {
    owner = "monocasual";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a5lqzxs417alpjr42q5197v6dwgrc74434znszk4lfhivr88p8v";
  };

  configureFlags = [ "--target=linux" ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    fltk
    libsndfile
    libsamplerate
    jansson
    rtmidi
    libXpm
    jack2
    alsaLib
    libpulseaudio
    libXinerama
    libXcursor
  ];

  meta = with lib; {
    description = "A free, minimal, hardcore audio tool for DJs, live performers and electronic musicians";
    homepage = "https://giadamusic.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petabyteboy ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isAarch64; # produces build failure on aarch64-linux
  };
}
