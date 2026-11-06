{
  lib,
  stdenv,
  fetchurl,
  writeTextFile,
  autoPatchelfHook,
  jdk,
  isabelle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kodkodi";
  version = "1.5.7";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/kodkodi-${finalAttrs.version}.tar.gz";
    hash = "sha256-BY5I2vLexZwTJnhSIIPciv08Cby4E8OhGpKNPO+RDqE=";
  };

  nativeBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    autoPatchelfHook
  ];

  buildInputs = [
    jdk
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/examples $out/share/java
    cp bin/kodkodi $out/bin
    cp jar/*.jar $out/share/java
    cp examples/*.kki $out/examples
  ''
  + lib.optionalString stdenv.hostPlatform.isx86_64 ''
    mkdir -p $out/lib
    cp jni/${isabelle.platform}/*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    addAutoPatchelfSearchPath ${jdk}/lib/openjdk/lib/
  ''
  + ''
    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "kodkodi-settings";
    text = ''
      KODKODI="${finalAttrs.finalPackage}"
      KODKODI_VERSION="${finalAttrs.version}"

      KODKODI_CLASSPATH="$KODKODI/share/java/antlr-runtime-3.1.1.jar:$KODKODI/share/java/kodkod-1.5.jar:$KODKODI/share/java/kodkodi-$KODKODI_VERSION.jar:$KODKODI/share/java/sat4j-2.3.jar"
      classpath "$KODKODI_CLASSPATH"
    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          export LD_LIBRARY_PATH="$KODKODI/lib:$LD_LIBRARY_PATH"
        ''
      else
        ''
          export JAVA_LIBRARY_PATH="$KODKODI/lib:$JAVA_LIBRARY_PATH"
        ''
    );
    destination = "/etc/settings";
  };
})
