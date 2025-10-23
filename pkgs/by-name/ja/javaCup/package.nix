{
  lib,
  stdenv,
  fetchurl,
  ant,
  jdk8,
  makeWrapper,
  stripJavaArchivesHook,
}:
let
  jdk = jdk8; # TODO: remove override https://github.com/NixOS/nixpkgs/pull/89731
in
stdenv.mkDerivation (finalAttrs: {
  pname = "java-cup";
  version = "11b-20160615";

  src = fetchurl {
    url = "http://www2.cs.tum.edu/projects/cup/releases/java-cup-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-4OdzYG5FzhqorROD5jk9U+2dzyhh5D76gZT1Z+kdv/o=";
  };

  sourceRoot = ".";

  patches = [ ./javacup-0.11b_beta20160615-build-xml-git.patch ];

  nativeBuildInputs = [
    ant
    jdk
    makeWrapper
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 dist/java-cup-11b.jar -t $out/share/java-cup
    install -Dm644 dist/java-cup-11b-runtime.jar -t $out/share/java

    makeWrapper ${jdk.jre}/bin/java $out/bin/javacup \
        --add-flags "-jar $out/share/java-cup/java-cup-11b.jar"

    runHook postInstall
  '';

  meta = {
    description = "LALR parser generator for Java";
    homepage = "http://www2.cs.tum.edu/projects/cup/";
    license = lib.licenses.mit;
    mainProgram = "javacup";
    maintainers = [ lib.maintainers.romildo ];
    platforms = lib.platforms.all;
  };
})
