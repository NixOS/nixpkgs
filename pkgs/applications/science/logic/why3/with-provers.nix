{ stdenv, makeWrapper, runCommand, symlinkJoin, why3 }:
provers:
let configAwkScript = runCommand "why3-conf.awk" { inherit provers; }
    ''
      for p in $provers; do
        for b in $p/bin/*; do
          BASENAME=$(basename $b)
          echo "/^command =/{ gsub(\"$BASENAME\", \"$b\") }" >> $out
        done
      done
      echo '{ print }' >> $out
    '';
in stdenv.mkDerivation {
  name = "${why3.name}-with-provers";

  phases = [ "buildPhase" "installPhase" ];

  buildInputs = [ why3 makeWrapper ] ++ provers;

  buildPhase = ''
      mkdir -p $out/share/why3/
      why3 config --detect-provers -C $out/share/why3/why3.conf
      awk -i inplace -f ${configAwkScript} $out/share/why3/why3.conf
  '';

  installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${why3}/bin/why3 $out/bin/why3 --add-flags "--extra-config $out/share/why3/why3.conf"
  '';
}
