{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "cables";
  version = "0.10.6";

  src = fetchurl {
    url = "https://github.com/cables-gl/cables_electron/releases/download/v${finalAttrs.version}/cables-${finalAttrs.version}-linux-x64.AppImage";
    sha256 = "sha256-Pk6rtWzIWzAlp5WwI7cKAjAlhjqLZJUO+39v44ZD93k=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/cables-${finalAttrs.version}.desktop $out/share/applications/cables.desktop
    install -m 444 -D ${finalAttrs.contents}/cables-${finalAttrs.version}.png $out/share/icons/hicolor/512x512/apps/cables.png
      substituteInPlace $out/share/applications/cables.desktop --replace-fail 'Exec=AppRun' 'Exec=cables'
  '';

  meta = {
    description = "Standalone version of cables, a tool for creating beautiful interactive content";
    homepage = "https://cables.gl";
    changelog = "https://cables.gl/changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rubikcubed ];
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
    mainProgram = "cables";
  };
})
