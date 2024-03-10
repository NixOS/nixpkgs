{ lib
, maven
, fetchFromGitHub
, buildGraalvmNativeImage
}:

let
  pname = "certificate-ripper";
  version = "2.2.0";

  jar = maven.buildMavenPackage {
    pname = "${pname}-jar";
    inherit version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      rev = version;
      hash = "sha256-snavZVLY8sHinLnG6k61eSQlR9sb8+k5tRHqu4kzQKM=";
    };

    patches = [
      ./make-deterministic.patch
      ./fix-test-temp-dir-path.patch
    ];

    mvnHash = "sha256-ahw9VVlvBPlWChcJzXFna55kxqVeJMmdaLtwWcJ+qSA=";

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
