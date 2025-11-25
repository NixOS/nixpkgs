{
  lib,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "ktfmt";
  version = "0.51";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ktfmt";
    tag = "v${version}";
    hash = "sha256-TIYV/V6vtGTTSLFf9dcKo8Ezx61e7Vvz3vQvbh0Kj/Y=";
  };

  patches = [ ./pin-default-maven-plugin-versions.patch ];

  mvnHash = "sha256-f/Uwc0ynROEKl2+zsgqj5ctRu1QcNblF5suU/0+fvKw=";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm644 core/target/ktfmt-*-jar-with-dependencies.jar $out/share/ktfmt/ktfmt.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/ktfmt \
      --add-flags "-jar $out/share/ktfmt/ktfmt.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Program that reformats Kotlin source code to comply with the common community standard for Kotlin code conventions";
    homepage = "https://github.com/facebook/ktfmt";
    license = licenses.asl20;
    mainProgram = "ktfmt";
    maintainers = with maintainers; [ ghostbuster91 ];
    inherit (jre_headless.meta) platforms;
  };
}
