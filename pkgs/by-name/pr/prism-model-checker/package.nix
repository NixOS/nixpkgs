{
  lib,
  stdenv,
  prism-model-checker-unwrapped,
  java,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  name = "prism-model-checker-${prism-model-checker-unwrapped.version}";
  nativeBuildInputs = [ makeWrapper ];
  paths = [
    prism-model-checker-unwrapped
    java
  ];
  postBuild = ''
    rm -rf $out/bin
    mkdir --parents $out/bin
    for f in $(ls ${prism-model-checker-unwrapped}/bin); do
      makeWrapper "${prism-model-checker-unwrapped}/bin/$f" "$out/bin/$f" --set JAVA_HOME ${java.home} --set PRISM_JAVA ${java.home}/bin/java --prefix PATH: ${lib.makeBinPath [ java ]}
    done
  '';
  meta = prism-model-checker-unwrapped.meta;
}
