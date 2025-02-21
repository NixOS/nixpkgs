{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "cherry-studio";
  version = "0.9.21";
  src = fetchurl {
    url = "https://github.com/CherryHQ/cherry-studio/releases/download/v${version}/Cherry-Studio-${version}-x86_64.AppImage";
    hash = "sha256-U/uFm7Wg3uKf+D9ET7JyGE6kt7Vk8CZmEwbm79jHHOI=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/cherrystudio.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/cherrystudio.desktop $out/share/applications/cherrystudio.desktop
    install -Dm 444 ${appimageContents}/usr/share/icons/hicolor/0x0/apps/cherrystudio.png \
      $out/share/icons/hicolor/0x0/apps/cherrystudio.png
  '';

  meta = {
    changelog = "https://github.com/CherryHQ/cherry-studio/releases/tag/v${version}";
    description = "A desktop client that supports for multiple LLM providers";
    homepage = "https://github.com/CherryHQ/cherry-studio";
    license = lib.licenses.free;
    mainProgram = "cherrystudio";
    maintainers = with lib.maintainers; [
      meowking
    ];
    platforms = lib.platforms.linux;
  };
}
