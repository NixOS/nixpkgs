{ lib, fetchFromGitHub, jre_headless, makeWrapper, maven }:

maven.buildMavenPackage rec {
  pname = "ktfmt";
  version = "0.46";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ktfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-OIbJ+J5LX6SPv5tuAiY66v/edeM7nFPHj90GXV6zaxw=";
  };

  mvnHash = "sha256-pzMjkkdkbVqVxZPW2I0YWPl5/l6+SyNkhd6gkm9Uoyc=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm644 core/target/ktfmt-*-jar-with-dependencies.jar $out/share/ktfmt/ktfmt.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/ktfmt \
      --add-flags "-jar $out/share/ktfmt/ktfmt.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A program that reformats Kotlin source code to comply with the common community standard for Kotlin code conventions.";
    homepage = "https://github.com/facebook/ktfmt";
    license = licenses.apsl20;
    mainProgram = "ktfmt";
    maintainers = with maintainers; [ ghostbuster91 ];
    inherit (jre_headless.meta) platforms;
  };
}
