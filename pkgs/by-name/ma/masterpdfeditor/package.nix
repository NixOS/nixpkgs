{ stdenv
, fetchurl
, sane-backends
, nss
, autoPatchelfHook
, lib
, libsForQt5
, pkcs11helper
}:

stdenv.mkDerivation rec {
  pname = "masterpdfeditor";
  version = "5.9.82";

  src = fetchurl {
    url = "https://code-industry.net/public/master-pdf-editor-${version}-qt5.x86_64.tar.gz";
    hash = "sha256-CbrhhQJ0iiXz8hUJEi+/xb2ZGbunuPuIIgmCRgJhNVU=";
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

  meta = with lib; {
    description = "Master PDF Editor";
    homepage = "https://code-industry.net/free-pdf-editor/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cmcdragonkai ];
    mainProgram = "masterpdfeditor5";
  };
}
