{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeDesktopItem,
  _7zz,
  makeWrapper,
}:

let
  pname = "filen-desktop";
  version = "3.0.47";

  desktopItem = makeDesktopItem {
    name = "filen-desktop";
    desktopName = "Filen Desktop";
    comment = "Encrypted Cloud Storage";
    icon = "filen-desktop";
    exec = "filen-desktop %u";
    categories = [ "Office" ];
  };

  sources = {
    x86_64-linux = fetchurl {
      url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v${version}/Filen_linux_x86_64.AppImage";
      hash = "sha256-keaD5PUjkoFrFTCuap4DvmYq5X3Tjnq+njtiLgAZ9W8=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/FilenCloudDienste/filen-desktop/releases/download/v${version}/Filen_mac_arm64.dmg";
      hash = "sha256-BB8ws2H7Wwf5A504DPnz5WsRgEkaHr9xHMXS2B1fdBs=";
    };
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = sources.x86_64-linux;
  };

  meta = {
    homepage = "https://filen.io/products/desktop";
    downloadPage = "https://github.com/FilenCloudDienste/filen-desktop/releases/";
    description = "Filen Desktop Client for Linux";
    longDescription = ''
      Encrypted Cloud Storage built for your Desktop.
      Sync your data, mount network drives, collaborate with others and access files natively — powered by robust encryption and seamless integration.
    '';
    mainProgram = "filen-desktop";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      smissingham
      kashw2
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };

  linux = appimageTools.wrapType2 {
    inherit pname version;

    src = sources.x86_64-linux;

    extraInstallCommands = ''
      mkdir -p $out/share
      cp -rt $out/share ${desktopItem}/share/applications ${appimageContents}/usr/share/icons
      chmod -R +w $out/share
      find $out/share/icons -type f -iname "*.png" -execdir mv {} "$pname.png" \;
    '';

    meta = meta // {
      platforms = lib.platforms.linux;
    };

  };

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    src = sources.aarch64-darwin;

    nativeBuildInputs = [
      _7zz
      makeWrapper
    ];

    unpackPhase = ''
      runHook preUnpack
      7zz x $src -x!Filen/Applications
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstallPhase
      mkdir -p $out/{Applications,bin}
      mv Filen.app $out/Applications
      makeWrapper $out/Applications/Filen.app/Contents/MacOS/Filen $out/bin/${pname}
      runHook postInstallPhase
    '';

    meta = meta // {
      platforms = lib.platforms.darwin;
    };
  });
in
if stdenv.isDarwin then darwin else linux
