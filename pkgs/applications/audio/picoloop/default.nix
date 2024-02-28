{ lib, stdenv, fetchFromGitHub, libpulseaudio, SDL2, SDL2_image, SDL2_ttf, alsa-lib, libjack2 }:

stdenv.mkDerivation rec {
  pname = "picoloop";
  version = "0.77e";

  src = fetchFromGitHub {
    repo = pname;
    owner = "yoyz";
    rev = "${pname}-${version}";
    sha256 = "0i8j8rgyha3ara6d4iis3wcimszf2csxdwrm5yq0wyhg74g7cvjd";
  };

  buildInputs = [
    libpulseaudio
    SDL2
    SDL2.dev
    SDL2_image
    SDL2_ttf
    alsa-lib
    libjack2
  ];

  sourceRoot = "${src.name}/picoloop";

  makeFlags = [ "-f Makefile.PatternPlayer_debian_RtAudio_sdl20" ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${SDL2.dev}/include/SDL2" ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    substituteInPlace SDL_GUI.cpp \
    --replace "\"font.ttf\"" "\"$out/share/font.ttf\"" \
    --replace "\"font.bmp\"" "\"$out/share/font.bmp\""
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp PatternPlayer_debian_RtAudio_sdl20 $out/bin/picoloop
    cp {font.*,LICENSE} $out/share
  '';

  meta = with lib; {
    description = "A synth and a stepsequencer (a clone of the famous nanoloop)";
    homepage = "https://github.com/yoyz/picoloop";
    platforms = platforms.linux;
    license = licenses.bsd3;
    mainProgram = "picoloop";
  };
}
