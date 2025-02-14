{
  lib,
  maven,
  fetchFromGitHub,
  buildGraalvmNativeImage,
}:

let
  pname = "certificate-ripper";
  version = "2.4.0";

  jar = maven.buildMavenPackage {
    pname = "${pname}-jar";
    inherit version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      tag = version;
      hash = "sha256-2EXALTGeGkHne335B1R42VrA5vMCMkFF5FBatAfO9Tc=";
    };

    patches = [
      ./pin-default-maven-plguin-versions.patch
      ./fix-test-temp-dir-path.patch
    ];

    mvnHash = "sha256-Nv/V2+QPSPMxkDcUh6gJrI6aSi+9O+brxpOZg/JPGxI=";

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
in
buildGraalvmNativeImage {
  inherit pname version;

  src = jar;

  executable = "crip";

  # Copied from pom.xml
  extraNativeImageBuildArgs = [
    "--no-fallback"
    "-H:EnableURLProtocols=https"
    "-H:EnableURLProtocols=http"
  ];

  meta = {
    changelog = "https://github.com/Hakky54/certificate-ripper/releases/tag/${jar.src.tag}";
    description = "CLI tool to extract server certificates";
    homepage = "https://github.com/Hakky54/certificate-ripper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
