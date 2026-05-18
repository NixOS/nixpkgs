{
  lib,
  fetchFromGitHub,
  maven,
  makeWrapper,
  stripJavaArchivesHook,
  jre,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "mustang";
  version = "2.23.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ZUGFeRD";
    repo = "mustangproject";
    tag = "core-${finalAttrs.version}";
    hash = "sha256-c9bj0aPS49xEPWCe/0jtRTnRwrP4BXypCPvjn3+LGyU=";
  };

  # The pom at the 2.23 tag wasn't updated, so patch it manually to actually match the version
  postPatch = ''
    substituteInPlace pom.xml library/pom.xml validator/pom.xml Mustang-CLI/pom.xml \
      --replace-fail 2.22.1-SNAPSHOT ${finalAttrs.version}
  '';

  mvnHash = "sha256-ekSgGKY3OMFAEM3bNByBXrU3tpbDcbJ0fmCTRz7NIkA=";

  nativeBuildInputs = [
    makeWrapper
    stripJavaArchivesHook
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 Mustang-CLI/target/Mustang-CLI-${finalAttrs.version}.jar $out/share/java/Mustang-CLI.jar
    install -Dm644 library/target/library-${finalAttrs.version}.jar $out/share/java/library.jar
    install -Dm644 validator/target/validator-${finalAttrs.version}.jar $out/share/java/validator.jar

    makeWrapper ${jre}/bin/java $out/bin/mustang \
      --argv0 Mustang \
      --add-flags "-jar $out/share/java/Mustang-CLI.jar"

    runHook postInstall
  '';

  meta = {
    description = "Open-source Java library and CLI for ZUGFeRD/Factur-X/XRechnung electronic invoices";
    homepage = "https://www.mustangproject.org/";
    changelog = "https://github.com/ZUGFeRD/mustangproject/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "mustang";
    maintainers = with lib.maintainers; [ kilyanni ];
    inherit (jre.meta) platforms;
  };
})
