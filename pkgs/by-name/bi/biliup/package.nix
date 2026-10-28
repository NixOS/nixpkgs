{
  biliup-unwrapped,
  lib,
  makeWrapper,
  runCommand,

  optionalDeps ? [
    ffmpeg-headless
    streamlink
    yt-dlp
  ],
  ffmpeg-headless,
  streamlink,
  yt-dlp,
}:
runCommand "biliup"
  {
    pname = "biliup";
    inherit (biliup-unwrapped) version;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [ makeWrapper ];

    passthru.unwrapped = biliup-unwrapped;

    meta = (biliup-unwrapped.meta or { }) // {
      mainProgram = "biliup";
    };
  }
  ''
    mkdir -p $out/bin
    makeWrapper ${lib.getExe biliup-unwrapped} "$out/bin/biliup" \
      --prefix PATH : ${lib.makeBinPath optionalDeps}
  ''
