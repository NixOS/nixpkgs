{ lib, buildEnv, k3b-original, cdrtools, makeWrapper }:

let
  binPath = lib.makeBinPath [ cdrtools ];
in buildEnv {
  name = "k3b-${k3b-original.version}";

  paths = [ k3b-original ];
  buildInputs = [ makeWrapper ];

  postBuild = ''
    # TODO: This could be avoided if buildEnv could be forced to create all directories
    if [ -L $out/bin ]; then
      rm $out/bin
      mkdir $out/bin
      for i in ${k3b-original}/bin/*; do
        ln -s $i $out/bin
      done
    fi
    wrapProgram $out/bin/k3b \
      --prefix PATH ':' ${binPath}
  '';
}
