{
  lib,
  maven,
  fetchFromGitHub,
  buildGraalvmNativeImage,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "certificate-ripper";
  version = "2.7.0";

  src = maven.buildMavenPackage {
    pname = "certificate-ripper-jar";
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      tag = finalAttrs.version;
      hash = "sha256-j3g38MecdYkkQxlmm9OVuK4k8kcPMcfxzZlluJRcBLg=";
    };

    patches = [
      ./pin-default-maven-plguin-versions.patch
      ./fix-test-temp-dir-path.patch
    ];

    mvnHash = "sha256-7DcgmgFbcJPNIaWPo57fsNOFgxYVR1Ja3eyH9YowGVM=";

    mvnParameters =
      let
        disabledTests = [
          # tests use network (?)
          "PemExportCommandShould#resolveRootCaOnlyWhenEnabled"
          "PemExportRequestShould#resolveRootCaOnlyWhenEnabled"
          "DerExportCommandShould#processSystemTrustedCertificates"
          "DerExportRequestShould#processSystemTrustedCertificates"
          "JksExportCommandShould#processSystemTrustedCertificates"
          "JksExportRequestShould#processSystemTrustedCertificates"
          "PemExportCommandShould#processSystemTrustedCertificates"
          "PemExportRequestShould#processSystemTrustedCertificates"
          "Pkcs12ExportCommandShould#processSystemTrustedCertificates"
          "Pkcs12ExportRequestShould#processSystemTrustedCertificates"

          # integration tests
          "MySQLClientRunnableIT#shouldPrintCertificates"
          "PostgresClientRunnableIT#shouldPrintCertificates"
          "SmtpClientRunnableIT#shouldPrintCertificates"
          "FtpClientRunnableIT#shouldPrintCertificates"
          "ImapClientRunnableIT#shouldPrintCertificates"
          "WebsocketClientRunnableIT#shouldPrintCertificates"
        ];
      in
      lib.escapeShellArgs [
        "-Pfat-jar"
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
