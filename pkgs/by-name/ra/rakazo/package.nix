{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "rakazo";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/elie222/rakazo/releases/download/v${version}/Rakazo-${version}.AppImage";
    hash = "sha256-RSdlRhKUXeJw3MdwwqwTCSqJQ2k8u2jHiid/4LYCLnQ=";
  };

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # appimageTools already provides the usual AppImage/Steam library set (gtk3,
  # nss, libgbm, libxkbcommon, alsa-lib, at-spi2-core, libsecret, ...).
  extraPkgs =
    pkgs: with pkgs; [
      libnotify # desktop notifications
      libva # hardware video decode
      xdg-utils # opening links through the desktop
    ];

  # The app ships electron-updater, which cannot write to /nix/store. Upstream
  # supports turning it off with RAKAZO_DISABLE_AUTO_UPDATE; /etc/profile is
  # sourced by the FHS init before the app starts.
  profile = ''
    export RAKAZO_DISABLE_AUTO_UPDATE=1
  '';

  extraInstallCommands = ''
    install -Dm644 ${contents}/rakazo.png $out/share/icons/hicolor/1024x1024/apps/rakazo.png

    install -Dm644 /dev/stdin $out/share/applications/rakazo.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Name=Rakazo
    GenericName=AI Teammates
    Comment=Desktop client for a self-hosted Rakazo server
    Exec=rakazo %U
    Icon=rakazo
    Terminal=false
    StartupNotify=true
    StartupWMClass=Rakazo
    Categories=Network;
    EOF
  '';

  meta = {
    description = "Desktop client for the self-hosted Rakazo AI teammate server";
    homepage = "https://rakazo.com";
    downloadPage = "https://rakazo.com/download";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.yswtrue ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
