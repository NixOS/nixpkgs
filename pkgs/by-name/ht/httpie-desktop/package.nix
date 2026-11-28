{
  appimageTools,
  lib,
  fetchurl,
  stdenv,
}:
appimageTools.wrapType2 (finalAttrs: {
  pname = "httpie-desktop";
  version = "2025.2.0";

  src =
    if stdenv.hostPlatform.system == "aarch64-linux" then
      fetchurl {
        url = "https://github.com/httpie/desktop/releases/download/v${finalAttrs.version}/HTTPie-${finalAttrs.version}-arm64.AppImage";
        hash = "sha256-FBzjlYwgCULgjaJUPALlqqRj7fZMps7hybt5m5EkeAo=";
      }
    else
      fetchurl {
        url = "https://github.com/httpie/desktop/releases/download/v${finalAttrs.version}/HTTPie-${finalAttrs.version}.AppImage";
        hash = "sha256-qFDiFXQbYAhweQhgYfZW/lUMtmw09tqT9t/GPJRtZU8=";
      };

  extraInstallCommands = ''
    install -Dm644 ${finalAttrs.contents}/httpie.desktop $out/share/applications/httpie.desktop
    substituteInPlace $out/share/applications/httpie.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=httpie-desktop'
    cp -r ${finalAttrs.contents}/usr/share/* $out/share
  '';

  meta = {
    description = "Cross-platform API testing client for humans. Painlessly test REST, GraphQL, and HTTP APIs";
    homepage = "https://github.com/httpie/desktop";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "httpie-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
