{ lib
, stdenv
, fetchFromGitHub
, flac
, libmad
, libpulseaudio
, libvorbis
, mpg123
, audioBackend ? if stdenv.isLinux then "alsa" else "portaudio"
, alsaSupport ? stdenv.isLinux
, alsa-lib
, dsdSupport ? true
, faad2Support ? true
, faad2
, ffmpegSupport ? true
, ffmpeg
, opusSupport ? true
, opusfile
, resampleSupport ? true
, soxr
, sslSupport ? true
, openssl
, portaudioSupport ? stdenv.isDarwin
, portaudio
, slimserver
, AudioToolbox
, AudioUnit
, Carbon
, CoreAudio
, CoreVideo
, VideoDecodeAcceleration
}:

let
  inherit (lib) optional optionals optionalString;

  pulseSupport = audioBackend == "pulse";

  binName = "squeezelite${optionalString pulseSupport "-pulse"}";

in
stdenv.mkDerivation {
  # the nixos module uses the pname as the binary name
  pname = binName;
  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
  version = "1.9.9.1449";

  src = fetchFromGitHub {
    owner = "ralph-irving";
    repo = "squeezelite";
    rev = "8581aba8b1b67af272b89b62a7a9b56082307ab6";
    hash = "sha256-/qyoc0/7Q8yiu5AhuLQFUiE88wf+/ejHjSucjpoN5bI=";
  };

  buildInputs = [ flac libmad libvorbis mpg123 ]
    ++ optional pulseSupport libpulseaudio
    ++ optional alsaSupport alsa-lib
    ++ optional portaudioSupport portaudio
    ++ optionals stdenv.isDarwin [ CoreVideo VideoDecodeAcceleration CoreAudio AudioToolbox AudioUnit Carbon ]
    ++ optional faad2Support faad2
    ++ optional ffmpegSupport ffmpeg
    ++ optional opusSupport opusfile
    ++ optional resampleSupport soxr
    ++ optional sslSupport openssl;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace opus.c \
      --replace "<opusfile.h>" "<opus/opusfile.h>"
  '';

  EXECUTABLE = binName;

  OPTS = [ "-DLINKALL" "-DGPIO" ]
    ++ optional dsdSupport "-DDSD"
    ++ optional (!faad2Support) "-DNO_FAAD"
    ++ optional ffmpegSupport "-DFFMPEG"
    ++ optional opusSupport "-DOPUS"
    ++ optional portaudioSupport "-DPORTAUDIO"
    ++ optional pulseSupport "-DPULSEAUDIO"
    ++ optional resampleSupport "-DRESAMPLE"
    ++ optional sslSupport "-DUSE_SSL";

  env = lib.optionalAttrs stdenv.isDarwin {
    LDADD = "-lportaudio -lpthread";
  };

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                   ${binName}
    install -Dm444 -t $out/share/doc/squeezelite *.txt *.md

    runHook postInstall
  '';

  passthru = {
    inherit (slimserver) tests;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = "https://github.com/ralph-irving/squeezelite";
    license = with licenses; [ gpl3Plus ] ++ optional dsdSupport bsd2;
    mainProgram = binName;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = if (audioBackend == "pulse") then platforms.linux else platforms.linux ++ platforms.darwin;
  };
}
