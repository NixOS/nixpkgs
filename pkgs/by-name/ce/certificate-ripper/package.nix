{
  lib,
  maven,
  fetchFromGitHub,
  buildGraalvmNativeImage,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "certificate-ripper";
  version = "2.4.1";

  src = maven.buildMavenPackage {
    pname = "certificate-ripper-jar";
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      tag = finalAttrs.version;
      hash = "sha256-qQ5BHH+DT1sGNDGzSbclqc6+byBxyP16qvm3k9E/Yks=";
    };

    patches = [
      ./pin-default-maven-plguin-versions.patch
      ./fix-test-temp-dir-path.patch
    ];

    mvnHash = "sha256-G2+Z1JyxTzCZzWjB8MQH1T9kwHjtRPag+bmzGXpQXw4=";

    mvnParameters =
      let
        disabledTests = [
          "PemExportCommandShould#resolveRootCaOnlyWhenEnabled" # uses network
          "DerExportCommandShould#processSystemTrustedCertificates"
          "JksExportCommandShould#processSystemTrustedCertificates"
          "PemExportCommandShould#processSystemTrustedCertificates"
          "Pkcs12ExportCommandShould#processSystemTrustedCertificates"
        ];
      in
      lib.escapeShellArgs [
        "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z" # make timestamp deterministic
        "-Dtest=${lib.concatMapStringsSep "," (t: "!" + t) disabledTests}"
      ];

    installPhase = ''
      install -Dm644 target/crip.jar $out
    '';
  };

  # Copied from pom.xml
  extraNativeImageBuildArgs = [
    "--no-fallback"
    "-H:EnableURLProtocols=https"
    "-H:EnableURLProtocols=http"
  ];

  meta = {
    changelog = "https://github.com/Hakky54/certificate-ripper/releases/tag/${finalAttrs.version}";
    description = "CLI tool to extract server certificates";
    homepage = "https://github.com/Hakky54/certificate-ripper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
    mainProgram = "crip";
  };
})
