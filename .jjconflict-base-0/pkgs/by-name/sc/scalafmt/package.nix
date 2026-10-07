{
  lib,
  stdenv,
  jre,
  coursier,
  makeWrapper,
  setJavaClassPath,
  callPackage,
  testers,
}:

let
  baseName = "scalafmt";
  version = "3.11.5";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:scalafmt-cli_2.13:${version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHash = "sha256-NTi63ufQE9FX6AR3TJMzE9rYm1FuKZVuXTTSaf3IxVc=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = baseName;
  inherit version;

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ deps ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    makeWrapper ${jre}/bin/java $out/bin/${baseName} \
      --add-flags "-cp $CLASSPATH org.scalafmt.cli.Cli"

    runHook postInstall
  '';

  passthru = {
    updateScript = {
      command = lib.getExe (callPackage ./update.nix { });
      supportedFeatures = [ "commit" ];
    };

    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Opinionated code formatter for Scala";
    homepage = "http://scalameta.org/scalafmt";
    changelog = "https://github.com/scalameta/scalafmt/releases/tag/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      agilesteel
      markus1189
    ];
    mainProgram = "scalafmt";
    # a jar plus a launcher wrapper, so it runs wherever the jre does
    platforms = jre.meta.platforms;
  };
})
