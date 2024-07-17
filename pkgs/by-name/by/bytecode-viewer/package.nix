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
  version = "2.12";

  src = fetchFromGitHub {
    owner = "Konloch";
    repo = "bytecode-viewer";
    rev = "v${version}";
    hash = "sha256-opAUmkEcWPOrcxAL+I1rBQXwHmvzbu0+InTnsg9r+z8=";
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

  mvnHash = "sha256-iAxzFq8nR9UiH8y3ZWmGuChZEMwQBAkN8wD+t9q/RWY=";

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

  meta = with lib; {
    homepage = "https://bytecodeviewer.com";
    description = "Lightweight user-friendly Java/Android Bytecode Viewer, Decompiler & More";
    mainProgram = "bytecode-viewer";
    maintainers = with maintainers; [
      shard7
      d3vil0p3r
    ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = with licenses; [ gpl3Only ];
  };
}
