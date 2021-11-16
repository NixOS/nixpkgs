{ config, lib, stdenv, autoreconfHook, fetchFromGitHub, pkg-config, makeWrapper
, alsa-lib, alsa-plugins, libtool, icu, pcre2
, pulseaudioSupport ? config.pulseaudio or false, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "mimic";
  version = "1.3.0.1";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mimic1";
    rev = version;
    sha256 = "1agwgby9ql8r3x5rd1rgx3xp9y4cdg4pi3kqlz3vanv9na8nf3id";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    alsa-plugins
    libtool
    icu
    pcre2
  ] ++ lib.optional pulseaudioSupport libpulseaudio;

  postInstall = ''
    wrapProgram $out/bin/mimic \
      --run "export ALSA_PLUGIN_DIR=${alsa-plugins}/lib/alsa-lib"
  '';

  meta = {
    description = "Mycroft's TTS engine, based on CMU's Flite (Festival Lite)";
    homepage = "https://mimic.mycroft.ai/";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.noneucat ];
  };
}
