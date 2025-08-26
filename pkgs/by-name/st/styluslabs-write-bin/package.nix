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

stdenv.mkDerivation rec {
  pname = "styluslabs-write-bin";
  version = "2025-01-10";

  src = fetchzip {
    url = "https://github.com/styluslabs/Write/releases/download/jan-2025/write-latest.tar.gz";
    hash = "sha256-aaScsqNLjGWm6XRifTey7x3dyYpRCkkjJyU7eHXN5Z4=";
  };

  buildInputs = [
    libsForQt5.qtbase # libQt5PrintSupport.so.5
    libsForQt5.qtsvg # libQt5Svg.so.5
    libGL # libGL.so.1
    libX11 # libX11.so.6
    libXi # libXi.so.6
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

    mkdir -p $out/share/{applications,icons/hicolor/144x144/apps}
    ln -s $out/opt/Write/Write.desktop -t $out/share/applications
    ln -s $out/opt/Write/Write144x144.png $out/share/icons/hicolor/144x144/apps/styluslabs-write.png
    substituteInPlace $out/opt/Write/Write.desktop \
      --replace-fail 'Exec=/opt/Write/Write' 'Exec=Write' \
      --replace-fail 'Icon=Write144x144' 'Icon=styluslabs-write'
  '';

  passthru.updateScript = ./update.rb;

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
