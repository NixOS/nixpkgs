{
  lib,
  maven,
  fetchFromGitHub,
  buildGraalvmNativeImage,
}:

buildGraalvmNativeImage (finalAttrs: {
  pname = "certificate-ripper";
  version = "2.7.1";

  src = maven.buildMavenPackage {
    pname = "certificate-ripper-jar";
    inherit (finalAttrs) version;

    src = fetchFromGitHub {
      owner = "Hakky54";
      repo = "certificate-ripper";
      tag = finalAttrs.version;
      hash = "sha256-yKBINzHhUpjqrbMIt3LulKtMLyuZvuBzBaR6wMs6lCI=";
    };

    patches = [
      ./pin-default-maven-plguin-versions.patch
    ];

    mvnHash = "sha256-ZuqPzFL7CJ/H6SBcQMwTMqBsKtlxv9oiQXXfFgMdQpE=";

    mvnParameters = lib.escapeShellArgs [
      # generate a singular .jar file
      "-Pfat-jar"
      # make the build timestamp deterministic
      "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
    ];

    # Integration tests and network based tests fail, let's not bother with blacklisting them one-by-one
    doCheck = false;

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
