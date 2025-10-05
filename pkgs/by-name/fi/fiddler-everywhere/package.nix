{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  writeScript,
}:

let
  pname = "fiddler-everywhere";
  version = "7.3.0";

  src = fetchurl {
    url = "https://downloads.getfiddler.com/linux/fiddler-everywhere-${version}.AppImage";
    hash = "sha256-M1SMWtIdgYpC+cwrN8Z6T+7tj4y07hho3akuy9j/l98=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/fiddler-everywhere.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=fiddler-everywhere'
    '';
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.icu ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/fiddler-everywhere.desktop $out/share/applications/fiddler-everywhere.desktop
    for i in 16 24 32 48 64 96 128 256 512 1024; do
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/''${i}x''${i}/apps/fiddler-everywhere.png \
        $out/share/icons/hicolor/''${i}x''${i}/apps/fiddler-everywhere.png
    done
    wrapProgram $out/bin/fiddler-everywhere --set DESKTOPINTEGRATION false
  '';

  passthru.updateScript = writeScript "update-fiddler-everywhere" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 common-updater-scripts

    set -eu -o pipefail

    version="$(curl -si https://api.getfiddler.com/linux/latest-linux \
      | grep -Fi 'Location:' \
      | pcre2grep -o1 'https://downloads.getfiddler.com/linux/fiddler-everywhere-(([0-9]\.?)+).AppImage')"
    update-source-version fiddler-everywhere "$version"
  '';

  meta = {
    description = "Web debugging proxy by Telerik";
    homepage = "https://www.telerik.com/fiddler/fiddler-everywhere";
    downloadPage = "https://www.telerik.com/download/fiddler-everywhere";
    changelog = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "fiddler-everywhere";
    platforms = [ "x86_64-linux" ];
  };
}
