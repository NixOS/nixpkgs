{
  lib,
  fetchurl,
  appimageTools,
  writeShellScript,
  curl,
  jq,
  nix-update,
  testers,
}:

let
  pname = "kdrive";
  version = "3.8.1.4";
  # kDrive displays "version 3.8.1 (build 4)" for version 3.8.1.4
  versionParts = lib.splitString "." version;
  displayVersion = lib.concatStringsSep "." (lib.take 3 versionParts);

  src = fetchurl {
    url = "https://download.storage.infomaniak.com/drive/desktopclient/kDrive-${version}-amd64.AppImage";
    hash = "sha256-KzJ0aRh2YFgtYZ5Aw1e4v7pQ63ODeS51gpozi3LfYEw=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  self = appimageTools.wrapType2 {
    inherit pname version src;
    executableName = "kDrive";

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/usr/share/applications/kDrive_client.desktop $out/share/applications/kDrive.desktop
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    passthru = {
      updateScript = writeShellScript "update-kdrive" ''
        set -euo pipefail
        latestVersion=$(${lib.getExe curl} -s "https://aur.archlinux.org/rpc/v5/info?arg[]=kdrive-bin" | ${lib.getExe jq} -r '.results[0].Version' | sed 's/-[0-9]*$//')
        ${lib.getExe nix-update} kdrive --version "$latestVersion"
      '';
      tests.version = testers.testVersion {
        package = self;
        version = displayVersion;
        command = "QT_QPA_PLATFORM=offscreen kDrive --version";
      };
    };

    meta = {
      description = "Desktop sync client for Infomaniak kDrive";
      longDescription = ''
        kDrive is a cloud storage service by Infomaniak that allows you to store,
        share and collaborate on files. This desktop client synchronizes your
        local folders with your kDrive cloud storage.
      '';
      homepage = "https://www.infomaniak.com/kdrive";
      downloadPage = "https://www.infomaniak.com/en/apps/download-kdrive";
      changelog = "https://github.com/Infomaniak/desktop-kDrive/releases/tag/${version}";
      license = lib.licenses.gpl3Plus;
      maintainers = with lib.maintainers; [ JalilArfaoui ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "kDrive";
    };
  };
in
self
