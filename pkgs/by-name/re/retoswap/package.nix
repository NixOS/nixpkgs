{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
}:
let
  version = "1.2.2";
  releaseTag = "1.2.2-reto-app";

  mkSrc = system: hash: {
    url = "https://github.com/retoaccess1/haveno-reto/releases/download/${releaseTag}/haveno-v${version}-linux-${system}.AppImage";
    hash = hash;
  };

  srcs = {
    x86_64-linux = mkSrc "x86_64" "sha256-M+I7LRH5aBj4YxnUYOFEcRV2MeugF6A3uhGAJzqVj4o=";
    aarch64-linux = mkSrc "aarch64" "sha256-at/ZMw1KeSLu8TBjaxoU5R9M6CnUGTuOZLHulHP6S3o=";
  };

  src = fetchurl srcs.${stdenv.hostPlatform.system};

  icon = fetchurl {
    url = "https://retoswap.com/images/webclip.png";
    hash = "sha256-Lp0nNKL/0EwjUxa7+YeezOCMQ5AFUaISibMOs5FxziY=";
  };
in
appimageTools.wrapType2 {
  pname = "haveno-reto";
  inherit version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256/apps

    cp ${icon} $out/share/icons/hicolor/256x256/apps/haveno-reto.png

    cat > $out/share/applications/haveno-reto.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=RetoSwap
    Exec=haveno-reto
    Icon=haveno-reto
    Categories=Finance;Network;
    EOF
  '';

  meta = {
    description = "P2P Monero decentralized exchange (DEX)";
    homepage = "https://retoswap.com";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ ];
  };
}
