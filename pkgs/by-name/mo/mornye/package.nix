{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:

let
  pname = "mornye";
  version = "5.3.1";

  arch =
    {
      x86_64-linux = "x86_64";
      aarch64-linux = "aarch64";
    }
    .${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/mornyeapp/Mornye-Desktop/releases/download/v${version}/Mornye-v${version}-linux-${arch}.AppImage";
    hash =
      {
        x86_64-linux = "sha256-ep1hRVVxQPNKYfgEUzWmyi9siOCrfUJdn066DtgqeFc=";
        aarch64-linux = "sha256-Ji5PrL8VNiTJBRe+OX7reB9t5tQBsSvkejoHPx6uD08=";
      }
      .${stdenv.hostPlatform.system};
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      json-glib
      libepoxy
      mpv-unwrapped
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];

  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/mornye.desktop" <<'DESKTOP'
    [Desktop Entry]
    Version=1.4
    Type=Application
    Name=Mornye
    Comment=Music player and library manager
    Exec=mornye %U
    Icon=mornye
    Terminal=false
    Categories=AudioVideo;Audio;Music;Player;
    MimeType=x-scheme-handler/mornye;
    StartupNotify=true
    DESKTOP

    icon=$(find ${appimageContents} -type f -iname '*mornye*.png' -print -quit)
    if [ -n "$icon" ]; then
      install -Dm644 "$icon" "$out/share/icons/hicolor/256x256/apps/mornye.png"
    fi
  '';

  meta = {
    description = "Desktop music player and library manager";
    homepage = "https://desktop.mornye.com";
    downloadPage = "https://github.com/mornyeapp/Mornye-Desktop/releases";
    license = lib.licenses.lgpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      gruvw
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "mornye";
  };
}
