{
  stdenv,
  lib,
  makeWrapper,
  jetbrains,
}:

stdenv.mkDerivation {
  name = "jbr-browser-test";

  src = ./BrowserTest.java;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jetbrains.jdk ];

  buildPhase = ''
    cp $src BrowserTest.java
    javac BrowserTest.java
  '';

  installPhase = ''
    mkdir --parents $out/{lib,bin}
    cp *.class $out/lib/
    makeWrapper ${lib.getBin jetbrains.jdk}/bin/java $out/bin/jbr-browser-test \
      --append-flags "-cp $out/lib BrowserTest"
  '';

  meta.mainProgram = "jbr-browser-test";
}
