{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  libxshmfence,
}:
let
  pname = "another-redis-desktop-manager";
  version = "1.7.1";
  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-linux-${version}-x86_64.AppImage";
          hash = "sha256-XuS4jsbhUproYUE2tncT43R6ErYB9WTg6d7s16OOxFQ=";
        };
        aarch64-linux = {
          url = "https://github.com/qishibo/AnotherRedisDesktopManager/releases/download/v${version}/Another-Redis-Desktop-Manager-linux-${version}-arm64.AppImage";
          hash = "sha256-0WXWl0UAQBqJlvt2MNpNHuqmEAlIlvY0FfHXu4LKkcY=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.system}");
  meta = {
    description = "Faster, better and more stable redis desktop manager";
    longDescription = ''
      Faster, better, more stable Redis Desktop (GUI) management client, compatible with Windows, Mac, Linux, superior performance, easy to load massive key values.
      Supports Sentinel, clustering, ssh channels, ssl authentication, stream, subscribe, tree view, command line, and dark mode; A variety of formatting methods, and even the ability to customize formatting scripts,
    '';
    homepage = "https://github.com/qishibo/AnotherRedisDesktopManager";
    changelog = "https://github.com/qishibo/AnotherRedisDesktopManager?tab=readme-ov-file#feature-log";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      joyanhui
    ];
    platforms = lib.platforms.linux;
    mainProgram = "another-redis-desktop-manager";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;
  extraPkgs = pkgs: [
    libxshmfence
  ];
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    install -Dm644 ${appimageContents}/usr/share/icons/hicolor/0x0/apps/another-redis-desktop-manager.png $out/share/icons/hicolor/0x0/apps/another-redis-desktop-manager.png
    cat > $out/share/applications/another-redis-desktop-manager.desktop  << EOF
    [Desktop Entry]
    Name=Another Redis Desktop Manager
    Exec=another-redis-desktop-manager
    Terminal=false
    Type=Application
    Icon=$out/share/icons/hicolor/0x0/apps/another-redis-desktop-manager.png
    StartupWMClass=Another Redis Desktop Manager
    X-AppImage-Version=${version}
    Comment=A faster, better and more stable redis desktop manager.
    Categories=Utility;
    EOF
  '';
}
