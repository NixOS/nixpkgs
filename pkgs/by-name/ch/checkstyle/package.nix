{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage (finalAttrs: {
  version = "13.8.0";
  pname = "checkstyle";

  src = fetchFromGitHub {
    owner = "checkstyle";
    repo = "checkstyle";
    tag = "checkstyle-${finalAttrs.version}";
    hash = "sha256-Nhn65Y6iz55wucAQ/DiF9VWm15O7m7+ZhOM+X4rIHGQ=";
  };

  mvnHash = "sha256-GhnxhSZX+plwQq9l4av6dqLEVp7HwT5aTVHKoTfaP8c=";

  nativeBuildInputs = [
    maven
    makeBinaryWrapper
  ];

  mvnParameters = lib.escapeShellArgs [ "-Passembly,no-validations" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/checkstyle
    install -Dm644 target/checkstyle-${finalAttrs.version}-all.jar $out/share/checkstyle/checkstyle-all.jar

    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/share/checkstyle/checkstyle-all.jar"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Checks Java source against a coding standard";
    mainProgram = "checkstyle";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = "https://checkstyle.org/";
    changelog = "https://checkstyle.org/releasenotes.html#Release_${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      pSub
      progrm_jarvis
    ];
    inherit (jre.meta) platforms;
  };
})
