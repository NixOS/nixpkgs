{
  stdenv,
  lib,
  coursier,
  jre,
  makeWrapper,
  setJavaClassPath,
  callPackage,
  testers,
  extraJavaOpts ? "-XX:+UseG1GC -XX:+UseStringDeduplication -Xss4m -Xms100m",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metals";
  version = "1.6.8";

  nativeBuildInputs = [
    makeWrapper
    setJavaClassPath
  ];
  buildInputs = [ finalAttrs.passthru.deps ];

  dontUnpack = true;

  # metals itself is class-file 61; its own docs' minimum of 11 is the floor for
  # the jdk it indexes and builds against, which metals.javaHome still selects.
  installPhase =
    assert lib.assertMsg (lib.versionAtLeast jre.version "17.0.0") ''
      metals requires Java 17 or newer, but ${jre.name} is ${jre.version}
    '';
    ''
      runHook preInstall

      mkdir -p $out/bin

      makeWrapper ${jre}/bin/java $out/bin/metals \
        --prefix PATH : ${lib.makeBinPath [ jre ]} \
        --set JAVA_HOME ${jre.home} \
        --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.Main"

      makeWrapper ${jre}/bin/java $out/bin/metals-mcp \
        --prefix PATH : ${lib.makeBinPath [ jre ]} \
        --set JAVA_HOME ${jre.home} \
        --add-flags "${extraJavaOpts} -cp $CLASSPATH scala.meta.metals.McpMain"

      runHook postInstall
    '';

  # --version reaches repo1.maven.org to list the Scala versions it supports,
  # but tolerates being offline: the version line still prints and the exit
  # code stays 0, which is what makes this safe inside the sandbox.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/metals --version | grep -q "${finalAttrs.version}"
    $out/bin/metals-mcp --version | grep -q "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = {
    command = lib.getExe (callPackage ./update.nix { });
    supportedFeatures = [ "commit" ];
  };

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  passthru.deps = stdenv.mkDerivation {
    name = "metals-deps-${finalAttrs.version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/cs fetch org.scalameta:metals_2.13:${finalAttrs.version} org.scalameta:metals-mcp_2.13:${finalAttrs.version} > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-LdZ6I7zOUTHgS/TTo0T6Dh+Kb3YpgJg8gK0UngsA7Gs=";
  };

  meta = {
    homepage = "https://scalameta.org/metals/";
    changelog = "https://github.com/scalameta/metals/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    description = "Language server for Scala";
    mainProgram = "metals";
    # a jar plus a launcher wrapper, so it runs wherever the jre does
    platforms = jre.meta.platforms;
    maintainers = with lib.maintainers; [
      agilesteel
      fabianhjr
      jpaju
      tomahna
    ];
  };
})
