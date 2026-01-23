{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "ankama-launcher";
  version = "3.13.18";

  # The original URL for the launcher is:
  # https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage
  # As it does not encode the version, we use the wayback machine (web.archive.org) to get a fixed URL.
  # To update the client, head to web.archive.org and create a new snapshot of the download page.
  src = fetchurl {
    url = "https://web.archive.org/web/20251121131316/https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    hash = "sha256-0GI3qBt/hwRqmfvg817C5IiD8s9AYzTX6w2UAmyR02I=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

in

appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: [ pkgs.wine ];

  extraInstallCommands = ''
    desktop_file="${appimageContents}/zaap.desktop"

    nix_version="${version}"
    archive_version=$(grep -oP '(?<=X-AppImage-Version=).*' $desktop_file)

    if [[ "$archive_version" != "$nix_version"* ]]; then
      echo "ERROR - Version mismatch:"
      echo -e "\t- Expected (pkgs.ankama-launcher.version): $nix_version"
      echo -e "\t- Version found in 'zaap.desktop': $archive_version"
      echo -e "\n-> Update the version attribute of the derivation."
      echo "-> Note: Ignore the last part of the version: Do not write '3.12.24.19260' but '3.12.24'."
      exit 1
    fi

    install -m 444 -D "$desktop_file" $out/share/applications/ankama-launcher.desktop
    sed -i 's/.*Exec.*/Exec=ankama-launcher/' $out/share/applications/ankama-launcher.desktop
    install -m 444 -D ${appimageContents}/zaap.png $out/share/icons/hicolor/256x256/apps/zaap.png
  '';

  meta = {
    description = "Ankama Launcher";
    longDescription = ''
      Ankama Launcher is a portal that allows you to access Ankama's video games, VOD animations, webtoons, and livestreams, as well as download updates, stay up to date with the latest news, and chat with your friends.
    '';
    homepage = "https://www.ankama.com/en/launcher";
    license = lib.licenses.unfree;
    mainProgram = "ankama-launcher";
    maintainers = with lib.maintainers; [ harbiinger ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
