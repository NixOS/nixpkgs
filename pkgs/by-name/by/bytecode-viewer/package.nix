{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  icoutils,
  copyDesktopItems,
  makeDesktopItem,
}:

maven.buildMavenPackage rec {
  pname = "bytecode-viewer";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "Konloch";
    repo = "bytecode-viewer";
    rev = "v${version}";
    hash = "sha256-PWL9fFBWksIfCZuVH/QV0j47stZ4CFY24SIunp+DuUI=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "bytecode-viewer";
      desktopName = "Bytecode-Viewer";
      exec = meta.mainProgram;
      icon = "bytecode-viewer";
      comment = "A lightweight user-friendly Java/Android Bytecode Viewer, Decompiler & More.";
      categories = [ "Security" ];
      startupNotify = false;
    })
  ];

  patches = [
    # Make vendoring deterministic by pinning Maven plugin dependencies
    ./make-deterministic.patch
  ];

  mvnHash = "sha256-NmSme8Jea2VGE0HvdqfhAs+CI1ZD+5jqD06pFSfSr1o=";

  mvnParameters = "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z";

  nativeBuildInputs = [
    icoutils
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 target/Bytecode-Viewer-${version}.jar $out/share/bytecode-viewer/bytecode-viewer.jar

    mv "BCV Icon.ico" bytecode-viewer.ico
    icotool -x bytecode-viewer.ico

    for size in 16 32 48
    do
      install -Dm644 bytecode-viewer_*_$size\x$size\x32.png $out/share/icons/hicolor/$size\x$size/apps/bytecode-viewer.png
    done

    mkdir $out/bin
    makeWrapper ${lib.getExe jre} $out/bin/${meta.mainProgram} \
      --add-flags "-jar $out/share/bytecode-viewer/bytecode-viewer.jar"

    runHook postInstall
  '';

  meta = {
    homepage = "https://bytecodeviewer.com";
    description = "Lightweight user-friendly Java/Android Bytecode Viewer, Decompiler & More";
    mainProgram = "bytecode-viewer";
    maintainers = with lib.maintainers; [
      shard7
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.gpl3Only;
  };
}
