{
  appimageTools,
  fetchurl,
  lib,
  stdenvNoCC,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "silverbullet-desktop";
  version = "3.0.1";

  src =
    let
      sources = {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-bLKi9nct+kPajhgtWiiAX9J6OD8bPaAsFyuZiKlPF5g=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-Km2BgLvlv+IjftnhYDsbQjkqaS7IxEb5O/v0hsQCkVo=";
        };
      };
      inherit (stdenvNoCC.hostPlatform) system;
    in
    fetchurl {
      url = "https://release.silverbullet.md/electron/artifacts/${finalAttrs.version}/linux/x64/SilverBullet-${finalAttrs.version}-linux-${sources.${system}.arch}.AppImage";
      inherit (sources.${system}) hash;
    };
  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/silverbullet.desktop \
      $out/share/applications/silverbullet.desktop
    substituteInPlace $out/share/applications/silverbullet.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share/
  '';
  meta = {
    description = "Desktop client for SilverBullet, a markdown-based note-taking app.";
    homepage = "https://silverbullet.md";
    license = lib.licenses.unfree;
    mainProgram = "silverbullet-desktop";
    maintainers = with lib.maintainers; [ gs-101 ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
