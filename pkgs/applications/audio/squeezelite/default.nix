{ stdenv, fetchFromGitHub
, alsaLib, flac, libmad, libvorbis, mpg123
, dsdSupport ? true
, faad2Support ? true, faad2
, ffmpegSupport ? true, ffmpeg
, opusSupport ? true, opusfile
, resampleSupport ? true, soxr
, sslSupport ? true, openssl
}:

let
  concatStringsSep = stdenv.lib.concatStringsSep;
  optional = stdenv.lib.optional;
  opts = [ "-DLINKALL" ]
    ++ optional dsdSupport "-DDSD"
    ++ optional (!faad2Support) "-DNO_FAAD"
    ++ optional ffmpegSupport "-DFFMPEG"
    ++ optional opusSupport "-DOPUS"
    ++ optional resampleSupport "-DRESAMPLE"
    ++ optional sslSupport "-DUSE_SSL";

in stdenv.mkDerivation {
  pname = "squeezelite";

  # versions are specified in `squeezelite.h`
  # see https://github.com/ralph-irving/squeezelite/issues/29
  version = "1.9.6.1196";

  src = fetchFromGitHub {
    owner  = "ralph-irving";
    repo   = "squeezelite";
    rev    = "2b508464dce2cbdb2a3089c58df2a6fbc36328c0";
    sha256 = "024ypr1da2r079k3hgiifzd3d3wcfprhbl5zdm40zm0c7frzmr8i";
  };

  buildInputs = [ alsaLib flac libmad libvorbis mpg123 ]
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

  preBuild = ''
    export OPTS="${concatStringsSep " " opts}"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin                   squeezelite
    install -Dm644 -t $out/share/doc/squeezelite *.txt *.md

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Lightweight headless squeezebox client emulator";
    homepage = https://github.com/ralph-irving/squeezelite;
    license = with licenses; [ gpl3 ] ++ optional dsdSupport bsd2;
    maintainers = with maintainers; [ samdoshi ];
    platforms = platforms.linux;
  };
}
