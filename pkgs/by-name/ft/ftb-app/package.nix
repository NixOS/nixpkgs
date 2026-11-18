{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  nix-update-script,
}:
let
  pname = "ftb-app";
  version = "1.30.0";

  src =
    let
      src' =
        {
          aarch64-linux = {
            url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-arm64.AppImage";
            hash = "sha256-ldH3LhdXwS3vhiUYA/DdO2l7tRpRMs0EC70eeNNHcSc=";
          };
          x86_64-linux = {
            url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-x86_64.AppImage";
            hash = "sha256-NsZXfQj6exU2JWHCT+/NQJ/ivjVrIWVU7lajeS4bDrY=";
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
  appimageContents = appimageTools.extract { inherit pname src version; };
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
