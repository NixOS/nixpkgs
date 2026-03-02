{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
  maven,
  nix-update-script,
}:

maven.buildMavenPackage rec {
  version = "13.2.0";
  pname = "checkstyle";

  src = fetchFromGitHub {
    owner = "checkstyle";
    repo = "checkstyle";
    tag = "checkstyle-${version}";
    hash = "sha256-f9jJK9zp7sm8VEn30qQA73+ynARJWY3BxbSMEppEDlk=";
  };

  mvnHash = "sha256-+l3ubVFWx1QVTSgwVv0yGVyh8RPnxyHBU/vKE4sBRoE=";

  nativeBuildInputs = [
    maven
    makeBinaryWrapper
  ];

  mvnParameters = lib.escapeShellArgs [ "-Passembly,no-validations" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/checkstyle
    install -Dm644 target/checkstyle-${version}-all.jar $out/share/checkstyle/checkstyle-all.jar

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
    changelog = "https://checkstyle.org/releasenotes.html#Release_${version}";
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
}
