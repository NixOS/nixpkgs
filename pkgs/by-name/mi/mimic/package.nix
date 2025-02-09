{
  config,
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  makeWrapper,
  alsa-lib,
  alsa-plugins,
  libtool,
  icu,
  pcre2,
  pulseaudioSupport ? config.pulseaudio or false,
  libpulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "mimic";
  version = "1.3.0.1";

  src = fetchFromGitHub {
    owner = "MycroftAI";
    repo = "mimic1";
    rev = version;
    sha256 = "1agwgby9ql8r3x5rd1rgx3xp9y4cdg4pi3kqlz3vanv9na8nf3id";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #   https://github.com/MycroftAI/mimic1/pull/216
    (fetchpatch {
      name = "fno-common";
      url = "https://github.com/MycroftAI/mimic1/commit/77b36eaeb2c38eba571b8db7e9bb0fd507774e6d.patch";
      sha256 = "0n3hqrfpbdp44y0c8bq55ay9m4c96r09k18hjxka4x54j5c7lw1m";
    })
  ];

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

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=free-nonheap-object"
  ];

  postInstall = ''
    wrapProgram $out/bin/mimic \
      --run "export ALSA_PLUGIN_DIR=${alsa-plugins}/lib/alsa-lib"
  '';

  meta = {
    description = "Mycroft's TTS engine, based on CMU's Flite (Festival Lite)";
    homepage = "https://mimic.mycroft.ai/";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fx-chun ];
  };
}
