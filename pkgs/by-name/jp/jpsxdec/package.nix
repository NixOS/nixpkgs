{ lib
, stdenv
, fetchFromGitHub
, ant
, jdk8 # the build script wants JAVA 8 for compilation
, jre # version can be >= 8 (latest version by default)
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, stripJavaArchivesHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jpsxdec";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "m35";
    repo = "jpsxdec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PZOc5mpnUiUyydWyfZjWuPG4w+tRd6WLJ6YQMqu/95I=";
  };

  sourceRoot = "${finalAttrs.src.name}/jpsxdec";

  nativeBuildInputs = [
    ant
    jdk8
    makeWrapper
    copyDesktopItems
    stripJavaArchivesHook
  ];

  buildPhase = ''
    runHook preBuild
    ant release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/jpsxdec
    mv _ant/release/{doc,*.jar} $out/share/jpsxdec
    install -Dm644 src/jpsxdec/gui/icon48.png $out/share/pixmaps/jpsxdec.png

    makeWrapper ${jre}/bin/java $out/bin/jpsxdec \
        --add-flags "-jar $out/share/jpsxdec/jpsxdec.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "jpsxdec";
      exec = "jpsxdec";
      icon = "jpsxdec";
      desktopName = "jPSXdec";
      comment = finalAttrs.meta.description;
      categories = [ "AudioVideo" "Utility" ];
    })
  ];

  meta = with lib; {
    changelog = "https://github.com/m35/jpsxdec/blob/${finalAttrs.src.rev}/jpsxdec/doc/CHANGES.txt";
    description = "Cross-platform PlayStation 1 audio and video converter";
    homepage = "https://jpsxdec.blogspot.com/";
    license = {
      url = "https://raw.githubusercontent.com/m35/jpsxdec/${finalAttrs.src.rev}/.github/LICENSE.md";
      free = true;
    };
    mainProgram = "jpsxdec";
    maintainers = with maintainers; [ zane ];
    platforms = platforms.all;
  };
})
