{ lib, maven, fetchFromGitHub, makeWrapper, jre }:

maven.buildMavenPackage rec {
  pname = "kotlin-interactive-shell";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Kotlin";
    repo = "kotlin-interactive-shell";
    rev = "v${version}";
    hash = "sha256-3DTyo7rPswpEVzFkcprT6FD+ITGJ+qCXFKXEGoCK+oE=";
  };

  mvnHash = "sha256-UHtvBVw35QBwgCD+nSduR0924ANAOfwrr/a4qPEYsrM=";
  mvnParameters = "compile";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp lib/ki-shell.jar $out/lib/ki-shell.jar
    makeWrapper ${lib.getExe jre} $out/bin/ki \
      --add-flags "-jar $out/lib/ki-shell.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kotlin Language Interactive Shell";
    longDescription = ''
      The shell is an extensible implementation of Kotlin REPL with a rich set of features including:
      - Syntax highlight
      - Type inference command
      - Downloading dependencies in runtime using Maven coordinates
      - List declared symbols
    '';
    homepage = "https://github.com/Kotlin/kotlin-interactive-shell";
    license = licenses.asl20;
    maintainers = [ maintainers.starsep ];
    platforms = jre.meta.platforms;
    mainProgram = "ki";
  };
}
