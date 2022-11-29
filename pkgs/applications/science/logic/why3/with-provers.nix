{ stdenv, makeWrapper, runCommand, why3 }:
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
in
stdenv.mkDerivation {
  pname = "${why3.pname}-with-provers";
  version = why3.version;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ why3 ] ++ provers;

  dontUnpack = true;

  buildPhase = ''
    mkdir -p $out/share/why3/
    why3 config detect -C $out/share/why3/why3.conf
    awk -i inplace -f ${configAwkScript} $out/share/why3/why3.conf
  '';

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${why3}/bin/why3 $out/bin/why3 --add-flags "--config $out/share/why3/why3.conf"
  '';
}
