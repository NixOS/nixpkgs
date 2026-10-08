{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  popt,
  alsa-lib,
  alsa-plugins,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "nano-tts";
  version = "unstable-2021-02-22";

  src = fetchFromGitHub {
    repo = "nanotts";
    owner = "gmn";
    rev = "d8b91f3d9d524c30f6fe8098ea7a0a638c889cf9";
    sha256 = "sha256-bFu3U50zc90iQeWkqOsCipkueJUZI3cW5342jjYSnGI=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    makeWrapper
  ];
  buildInputs = [
    popt
    alsa-lib
  ];

  patchPhase = ''
    # fix 64-bit compilation error in picoapi.c: picoos_uint32 vs picoos_objsize_t
    substituteInPlace svoxpico/picoapi.c \
      --replace-fail 'picoos_uint32 rest_mem_size;' 'picoos_objsize_t rest_mem_size;'

    substituteInPlace "src/main.cpp" --replace "/usr/share/pico/lang" "$out/share/lang"
    echo "" > update_build_version.sh
  '';

  installPhase = ''
    install -Dm755 -t $out/bin nanotts
    install -Dm644 -t $out/share/lang $src/lang/*
    wrapProgram $out/bin/nanotts \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.3)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Speech synthesizer commandline utility that improves pico2wave, included with SVOX PicoTTS";
    homepage = "https://github.com/gmn/nanotts";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.strikerlulu ];
    platforms = lib.platforms.linux;
    mainProgram = "nanotts";
  };
}
