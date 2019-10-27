{ stdenv, symlinkJoin, makeWrapper, mpv, scripts ? [] }:

symlinkJoin {
  name = "mpv-with-scripts-${mpv.version}";

  paths = [ mpv ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/mpv \
      --add-flags "${stdenv.lib.concatMapStringsSep " " (x: "--script=" + x) scripts}"
  '';
}
