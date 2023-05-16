{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
=======
, alsa-lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flac
, libmad
, libpulseaudio
, libvorbis
, mpg123
<<<<<<< HEAD
, audioBackend ? if stdenv.isLinux then "alsa" else "portaudio"
, alsaSupport ? stdenv.isLinux
, alsa-lib
=======
, audioBackend ? "alsa"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, portaudioSupport ? stdenv.isDarwin
, portaudio
, AudioToolbox
, AudioUnit
, Carbon
, CoreAudio
, CoreVideo
, VideoDecodeAcceleration
}:

let
  inherit (lib) optional optionals optionalString;
=======
}:

let
  inherit (lib) optional optionalString;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pulseSupport = audioBackend == "pulse";

  binName = "squeezelite${optionalString pulseSupport "-pulse"}";

in
stdenv.mkDerivation {
  # the nixos module uses the pname as the binary name
  pname = binName;
  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
<<<<<<< HEAD
  version = "1.9.9.1449";
=======
  version = "1.9.9.1430";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ralph-irving";
    repo = "squeezelite";
<<<<<<< HEAD
    rev = "8581aba8b1b67af272b89b62a7a9b56082307ab6";
    hash = "sha256-/qyoc0/7Q8yiu5AhuLQFUiE88wf+/ejHjSucjpoN5bI=";
  };

  buildInputs = [ flac libmad libvorbis mpg123 ]
    ++ optional pulseSupport libpulseaudio
    ++ optional alsaSupport alsa-lib
    ++ optional portaudioSupport portaudio
    ++ optionals stdenv.isDarwin [ CoreVideo VideoDecodeAcceleration CoreAudio AudioToolbox AudioUnit Carbon ]
=======
    rev = "663db8f64d73dceca6a2a18cdb705ad846daa272";
    hash = "sha256-PROb6d5ixO7lk/7wsjh2vkPkPgAvd6x+orQOY078IAs=";
  };

  buildInputs = [ flac libmad libvorbis mpg123 ]
    ++ lib.singleton (if pulseSupport then libpulseaudio else alsa-lib)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    ++ optional portaudioSupport "-DPORTAUDIO"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ optional pulseSupport "-DPULSEAUDIO"
    ++ optional resampleSupport "-DRESAMPLE"
    ++ optional sslSupport "-DUSE_SSL";

<<<<<<< HEAD
  env = lib.optionalAttrs stdenv.isDarwin {
    LDADD = "-lportaudio -lpthread";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                   ${binName}
    install -Dm444 -t $out/share/doc/squeezelite *.txt *.md

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = "https://github.com/ralph-irving/squeezelite";
    license = with licenses; [ gpl3Plus ] ++ optional dsdSupport bsd2;
    maintainers = with maintainers; [ adamcstephens ];
<<<<<<< HEAD
    platforms = if (audioBackend == "pulse") then platforms.linux else platforms.linux ++ platforms.darwin;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
