{ lib
, maven
, fetchFromGitHub
, buildGraalvmNativeImage
}:

let
  pname = "certificate-ripper";
  version = "2.3.0";

  jar = maven.buildMavenPackage {
    pname = "${pname}-jar";
    inherit version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      rev = version;
      hash = "sha256-q/UhKLFAre3YUH2W7e+SH4kRM0GIZAUyNJFDm02eL+8=";
    };

    patches = [
      ./pin-default-maven-plguin-versions.patch
      ./fix-test-temp-dir-path.patch
    ];

    mvnHash = "sha256-/iy7DXBAyq8TIpvrd2WAQh+9OApfxCWo1NoGwbzbq7s=";

    mvnParameters = lib.escapeShellArgs [
      "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z" # make timestamp deterministic
      "-Dtest=!PemExportCommandShould#resolveRootCaOnlyWhenEnabled" # disable test using network
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
    "-H:ReflectionConfigurationResources=graalvm_config.json"
    "-H:EnableURLProtocols=https"
    "-H:EnableURLProtocols=http"
  ];

  meta = {
    changelog = "https://github.com/Hakky54/certificate-ripper/releases/tag/${version}";
    description = "A CLI tool to extract server certificates";
    homepage = "https://github.com/Hakky54/certificate-ripper";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
