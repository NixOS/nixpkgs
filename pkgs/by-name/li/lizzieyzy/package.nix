{
  lib,
  fetchFromGitHub,
  makeBinaryWrapper,
  jre,
  maven,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "lizzieyzy";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "yzyray";
    repo = "lizzieyzy";
    tag = "${finalAttrs.version}";
    hash = "sha256-CVRJww1wNO9Ofpq7tu1SpcNL0c4WryhbMeLr2vH6IjQ=";
  };

  mvnHash = "sha256-Lc6JO0c8QCQVjWxNFydyi16JHVnq35B1XGuJ+Qlb3Ck=";

  nativeBuildInputs = [
    maven
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/lizzieyzy
    install -Dm644 target/lizzie-yzy${finalAttrs.version}.jar $out/share/lizzieyzy/lizzie-yzy.jar
    install -Dm644 target/lizzie-yzy${finalAttrs.version}-shaded.jar $out/share/lizzieyzy/lizzie-yzy-shaded.jar

    makeWrapper ${jre}/bin/java $out/bin/lizzieyzy \
      --add-flags "-jar $out/share/lizzieyzy/lizzie-yzy-shaded.jar"

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "LizzieYzy is a GUI for Game of Go";
    mainProgram = "lizzieyzy";
    longDescription = ''
      LizzieYzy is a graphical interface that supports multiple Go Engines such
      as Katago, LeelaZero, Leela, ZenGTP, SAI, Pachi or other GTP engines.
    '';
    homepage = "https://github.com/yzyray/lizzieyzy/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
    ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      omnipotententity
    ];
    inherit (jre.meta) platforms;
  };
})
