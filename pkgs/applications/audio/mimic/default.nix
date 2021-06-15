{ config, lib, stdenv, autoreconfHook, fetchFromGitHub, pkg-config
, alsa-lib, libtool, icu
, pulseaudioSupport ? config.pulseaudio or false, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "mimic";
  version = "1.2.0.2";

  src = fetchFromGitHub {
    rev = version;
    repo = "mimic";
    owner = "MycroftAI";
    sha256 = "1wkpbwk88lsahzkc7pzbznmyy0lc02vsp0vkj8f1ags1gh0lc52j";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libtool
    icu
  ] ++ lib.optional pulseaudioSupport libpulseaudio;

  meta = {
    description = "Mycroft's TTS engine, based on CMU's Flite (Festival Lite)";
    homepage = "https://mimic.mycroft.ai/";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.noneucat ];
  };
}
