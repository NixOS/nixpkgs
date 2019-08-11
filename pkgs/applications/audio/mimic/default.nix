{ config, stdenv, autoreconfHook, fetchFromGitHub, pkgconfig
, alsaLib, libtool, icu
, pulseaudioSupport ? config.pulseaudio or false, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "mimic-${version}";
  version = "1.2.0.2";

  src = fetchFromGitHub {
    rev = version;
    repo = "mimic";
    owner = "MycroftAI";
    sha256 = "1wkpbwk88lsahzkc7pzbznmyy0lc02vsp0vkj8f1ags1gh0lc52j";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    alsaLib
    libtool
    icu
  ] ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  meta = {
    description = "Mycroft's TTS engine, based on CMU's Flite (Festival Lite)";
    homepage = https://mimic.mycroft.ai/;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.noneucat ];
  };
}
