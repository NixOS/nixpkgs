{ lib, symlinkJoin, k3b-original, cdrtools, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in symlinkJoin {
  name = "k3b-${k3b-original.version}";

  paths = [ k3b-original ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/k3b \
      --prefix PATH ':' ${binPath}
  '';
}
