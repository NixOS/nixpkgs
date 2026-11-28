{
  lib,
  stdenv,
  faircamp,
  ffmpeg,
}:

stdenv.mkDerivation {
  name = "faircamp-test-wav";
  meta.timeout = 60;
  buildCommand = ''
    mkdir album
    ${lib.getExe ffmpeg} -f lavfi -i "sine=frequency=440:duration=1" album/track.wav
    ${lib.getExe' faircamp "faircamp-cli"} build --non-interactive --build-dir $out
  '';
}
