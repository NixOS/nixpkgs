{
  runCommand,
  mcat-unwrapped,
  makeWrapper,
  lib,
  chromium,
  ffmpeg-headless,
  useChromium ? false,
  useFfmpeg ? false,
}:

runCommand "mcat"
  {
    pname = "mcat";
    inherit (mcat-unwrapped) version meta;

    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    ln -s "${mcat-unwrapped}/share" "$out/share"
    makeWrapper ${lib.getExe mcat-unwrapped} $out/bin/mcat --prefix PATH : ${
      lib.makeBinPath ((lib.optional useChromium chromium) ++ (lib.optional useFfmpeg ffmpeg-headless))
    }
  ''
