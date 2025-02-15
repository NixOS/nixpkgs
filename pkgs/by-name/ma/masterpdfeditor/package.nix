{
  stdenv,
  fetchurl,
  sane-backends,
  nss,
  autoPatchelfHook,
  lib,
  libsForQt5,
  pkcs11helper,
}:

stdenv.mkDerivation rec {
  pname = "masterpdfeditor";
  version = "5.9.86";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
    in
    fetchurl {
      url = selectSystem {
        x86_64-linux = "https://code-industry.net/public/master-pdf-editor-${version}-qt5.x86_64-qt_include.tar.gz";
        aarch64-linux = "https://code-industry.net/public/master-pdf-editor-${version}-qt5.arm64.tar.gz";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-QBwcsEz13+EdgkKJRdmdsb6f3dt3N6WR/EEACdWbYNo=";
        aarch64-linux = "sha256-OTn5Z82fRMLQwVSLwoGAaj9c9SfEicyl8e1A1ICOUf0=";
      };
    };

  nativeBuildInputs = [
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    nss
    qtbase
    qtsvg
    sane-backends
    stdenv.cc.cc
    pkcs11helper
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    p=$out/opt/masterpdfeditor
    mkdir -p $out/bin

    substituteInPlace masterpdfeditor5.desktop \
      --replace-fail 'Exec=/opt/master-pdf-editor-5' "Exec=$out/bin" \
      --replace-fail 'Path=/opt/master-pdf-editor-5' "Path=$out/bin" \
      --replace-fail 'Icon=/opt/master-pdf-editor-5' "Icon=$out/share/pixmaps"

    install -Dm644 -t $out/share/pixmaps      masterpdfeditor5.png
    install -Dm644 -t $out/share/applications masterpdfeditor5.desktop
    install -Dm755 -t $p                      masterpdfeditor5
    install -Dm644 license_en.txt $out/share/$name/LICENSE
    ln -s $p/masterpdfeditor5 $out/bin/masterpdfeditor5
    cp -v -r stamps templates lang fonts $p

    runHook postInstall
  '';

  meta = {
    description = "Master PDF Editor";
    homepage = "https://code-industry.net/free-pdf-editor/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ cmcdragonkai ];
    mainProgram = "masterpdfeditor5";
  };
}
