{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libsForQt5,
  cups,
  libinput,
  mtdev,
  nss,
  pkcs11helper,
  sane-backends,
  common-updater-scripts,
  nix-update,
  writeShellScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "masterpdfeditor";
  version = "5.9.89";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
    in
    fetchurl {
      url = selectSystem {
        x86_64-linux = "https://code-industry.net/public/master-pdf-editor-${finalAttrs.version}-qt5.x86_64-qt_include.tar.gz";
        aarch64-linux = "https://code-industry.net/public/master-pdf-editor-${finalAttrs.version}-qt5.arm64.tar.gz";
      };
      hash = selectSystem {
        x86_64-linux = "sha256-HTYFo3tZD1JiYpsx/q9mr1Sp9JIWA6Kp0ThzmDcvxmo=";
        aarch64-linux = "sha256-uxCp9iv4923Qbyd2IldHm1/a50GU6VISSG6jfVzQqq4=";
      };
    };

  nativeBuildInputs = [
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    cups
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libinput
    mtdev
    nss
    pkcs11helper
    sane-backends
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace usr/share/applications/net.code-industry.masterpdfeditor5.desktop \
      --replace-fail "Exec=/opt/master-pdf-editor-5/masterpdfeditor5" "Exec=masterpdfeditor5" \
      --replace-fail "Path=/opt/master-pdf-editor-5" "Path=$out/share/masterpdfeditor" \
      --replace-fail "/opt/master-pdf-editor-5/masterpdfeditor5.png" "masterpdfeditor5"
    cp -r usr $out
    install -Dm755 masterpdfeditor5 -t $out/share/masterpdfeditor
    cp -r stamps templates lang fonts $out/share/masterpdfeditor
    mkdir $out/bin
    ln -s $out/share/masterpdfeditor/masterpdfeditor5 $out/bin/masterpdfeditor5

    runHook postInstall
  '';

  preFixup = ''
    patchelf $out/share/masterpdfeditor/masterpdfeditor5 \
      --add-needed libsmime3.so
  '';

  passthru.updateScript = writeShellScript "update-masterpdfeditor" ''
    latestVersion=$(curl -s https://code-industry.net/downloads/ | grep -A1 "fa-linux" | grep -oP 'Version\s+\K[\d.]+' | head -n 1)
    ${lib.getExe nix-update} masterpdfeditor --version $latestVersion --system x86_64-linux
    ${lib.getExe' common-updater-scripts "update-source-version"} masterpdfeditor $latestVersion --system=aarch64-linux --ignore-same-version
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
})
