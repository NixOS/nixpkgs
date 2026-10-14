{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  writeScript,
}:

let
  pname = "fiddler-everywhere";
  version = "8.2.0";

  src = fetchurl {
    url = "https://downloads.getfiddler.com/linux/fiddler-everywhere-${version}.AppImage";
    hash = "sha256-cP9DEnDUj0m3DJ71ASe3b3AH7ljUHOdw4bkQrHkey6I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.icu ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/fiddler-everywhere.desktop \
      $out/share/applications/fiddler-everywhere.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/fiddler-everywhere.png \
      $out/share/icons/hicolor/256x256/apps/fiddler-everywhere.png
    substituteInPlace $out/share/applications/fiddler-everywhere.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=fiddler-everywhere'
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
    changelog = "https://www.telerik.com/support/whats-new/fiddler-everywhere/release-history/fiddler-everywhere-v${version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "fiddler-everywhere";
    platforms = [ "x86_64-linux" ];
  };
}
