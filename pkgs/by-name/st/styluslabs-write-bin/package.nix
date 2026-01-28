{
  stdenv,
  lib,
  qt5,
  libsForQt5,
  libGL,
  libX11,
  libXi,
  fetchzip,
  autoPatchelfHook,
}:

stdenv.mkDerivation {
  pname = "styluslabs-write-bin";
  version = "2025-01-10";

  src = fetchzip {
    url = "https://github.com/styluslabs/Write/releases/download/jan-2025/write-latest.tar.gz";
    hash = "sha256-aaScsqNLjGWm6XRifTey7x3dyYpRCkkjJyU7eHXN5Z4=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libGL
    libX11
    libXi
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,opt/Write}
    cp * $out/opt/Write
    ln -s $out/opt/Write/Write -t $out/bin

    mkdir -p $out/share/{applications,pixmaps}
    ln -s $out/opt/Write/Write.desktop -t $out/share/applications
    ln -s $out/opt/Write/Write144x144.png $out/share/pixmaps/styluslabs-write.png
    substituteInPlace $out/opt/Write/Write.desktop \
      --replace-fail 'Exec=/opt/Write/Write' 'Exec=Write' \
      --replace-fail 'Icon=Write144x144' 'Icon=styluslabs-write'
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.styluslabs.com/";
    description = "Word processor for handwriting";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      oyren
      lukts30
      atemu
    ];
    mainProgram = "Write";
  };
}
