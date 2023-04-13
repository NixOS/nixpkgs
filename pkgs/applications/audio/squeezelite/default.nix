{ lib
, stdenv
, fetchFromGitHub
, alsa-lib
, flac
, libmad
, libpulseaudio
, libvorbis
, mpg123
, audioBackend ? "alsa"
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
}:

let
  inherit (lib) optional optionalString;

  pulseSupport = audioBackend == "pulse";

  binName = "squeezelite${optionalString pulseSupport "-pulse"}";

in
stdenv.mkDerivation {
  # the nixos module uses the pname as the binary name
  pname = binName;
  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
  version = "1.9.9.1428";

  src = fetchFromGitHub {
    owner = "ralph-irving";
    repo = "squeezelite";
    rev = "74fe7934ec60cc31565f088796f56e911f51679c";
    hash = "sha256-85Pz6psyK3VXOIrINcoIeHZT5j9UfJqWIxTavwqHx04=";
  };

  buildInputs = [ flac libmad libvorbis mpg123 ]
    ++ lib.singleton (if pulseSupport then libpulseaudio else alsa-lib)
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
    ++ optional pulseSupport "-DPULSEAUDIO"
    ++ optional resampleSupport "-DRESAMPLE"
    ++ optional sslSupport "-DUSE_SSL";

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
    platforms = platforms.linux;
  };
}
