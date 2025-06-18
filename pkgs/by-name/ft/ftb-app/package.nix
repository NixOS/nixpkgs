{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  nix-update-script,
}:
let
  pname = "ftb-app";
  version = "1.27.2";

  src =
    let
      src' =
        {
          aarch64-linux = {
            url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-arm64.AppImage";
            hash = "sha256-il7DIY1c5TDmRSzc86BTOCn4P20P3Wd4STkLGyFm2+c=";
          };
          x86_64-linux = {
            url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-x86_64.AppImage";
            hash = "sha256-35GEI1OBvVkUvHvQAzzGz8ux9h+5W3acH0Wr5VkqyBw=";
          };
        }
        .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchurl src';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feed the Beast desktop app";
    homepage = "https://www.feed-the-beast.com/ftb-app";
    changelog = "https://www.feed-the-beast.com/ftb-app/changes#${version}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ nagymathev ];
    mainProgram = "ftb-app"; # This might need a change for darwin
    platforms = with lib.platforms; linux;
  };
in
let
  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit
    pname
    src
    version
    passthru
    meta
    ;

  extraInstallCommands = ''
    for size in 16x16 32x32 48x48 64x64 128x128 256x256 512x512; do
      install -Dm644 ${appimageContents}/usr/share/icons/hicolor/$size/apps/ftb-app.png \
        $out/share/icons/hicolor/$size/apps/ftb-app.png
    done

    install -Dm644 ${appimageContents}/ftb-app.desktop \
      $out/share/applications/ftb-app.desktop
    substituteInPlace $out/share/applications/ftb-app.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=ftb-app'
  '';
}
