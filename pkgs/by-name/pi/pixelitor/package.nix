{
  lib,
  fetchFromGitHub,
  imagemagick,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "pixelitor";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "lbalazscs";
    repo = "Pixelitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-d8m22s9ynbApcKtZLFg6lef3AL+qFWp3+8fUhjoaIuo=";
  };

  mvnHash = "sha256-TVlh7iKIYMu+fM6vcmFeBMRicDVZmgopSWsFk0Y4Pjw=";

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;

  doCheck = false;

  installPhase = ''
    find . -name '*.jar'
    mkdir -p $out/bin $out/share/pixelitor
    install -Dm644 ./target/Pixelitor-${version}.jar $out/share/pixelitor/pixelitor.jar

    makeWrapper ${jre}/bin/java $out/bin/pixelitor \
      --add-flags "-jar $out/share/pixelitor/pixelitor.jar" \
      --prefix PATH : '${lib.makeBinPath [ imagemagick ]}'
  '';

  meta = {
    description = "Image editor with a special emphasis on non-destructive editing";
    homepage = "https://pixelitor.sourceforge.io/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "pixelitor";
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
}
