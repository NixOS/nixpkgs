{ lib
, runCommandLocal
, makeWrapper
, jre
}:

{ pname ? name # Default to eachother to allow either
, name ? pname
, src
, javaExecutable ? "${jre}/bin/java"
, ...
} @ inputs:

runCommandLocal name ({
  nativeBuildInputs = inputs.nativeBuildInputs or [ ] ++ [ makeWrapper ];
  meta = {
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  } // inputs.meta or { };
} // builtins.removeAttrs inputs [ "nativeBuildInputs" "meta" ]) ''
  mkdir -p $out/{bin,share/java}
  cp $src $out/share/java/$name.jar
  makeWrapper ${javaExecutable} $out/bin/$name \
    ''${makeWrapperArgs[@]-} \
    --add-flags "-jar $out/share/java/$name.jar"
''
