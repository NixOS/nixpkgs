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
  version = "1.9.9.1401";

  src = fetchFromGitHub {
    owner = "ralph-irving";
    repo = "squeezelite";
    rev = "894df3ea80f66a27a9ae5fab918acf62a6798b8b";
    hash = "sha256-LIi+9vb0+56AGvVrLx4gQaUkUNjIi6PmqrLViLT1DSU=";
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

  OPTS = [ "-DLINKALL" ]
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

  meta = with lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = "https://github.com/ralph-irving/squeezelite";
    license = with licenses; [ gpl3Plus ] ++ optional dsdSupport bsd2;
    maintainers = with maintainers; [ samdoshi ];
    platforms = platforms.linux;
  };
}
