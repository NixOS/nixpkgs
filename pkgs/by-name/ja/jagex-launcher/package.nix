{ lib, fetchurl, appimageTools, }:

let
  pname = "jagex-launcher";
  version = "0.1.6";

  src = fetchurl {
    url =
      "https://rs-launcher-updates.runescape.com/production/linux/x64/releases/${version}/jagex-launcher-beta-linux-x86_64.AppImage";
    hash = "sha256-JOSt564lBOSitSBnV307s2D8McMlzvOVz2Q8jVy91F8=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
            # The launcher checks for updates on startup via electron-updater, whose
            # AppImage "self update" replaces the running AppImage file. That cannot
            # work from the read-only Nix store, and an outdated pinned version would
            # otherwise nag/force-update on every launch. Removing the config file
            # makes the update check fail early, before any network request.
            rm $out/resources/app-update.yml

            # RuneLite and RuneScape are delivered to the launcher as AppImages which
            # it spawns as-is. Their type-2 runtime cannot FUSE-mount inside the
            # bubblewrap FHS sandbox this package runs in, so make it self-extract
            # instead. The launcher process inherits this export and passes it to the
            # spawned game clients.
            substituteInPlace $out/AppRun \
              --replace-fail '#!/usr/bin/env bash' '#!/usr/bin/env bash
      export APPIMAGE_EXTRACT_AND_RUN=1'
    '';
  };
in appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraPkgs = pkgs: with pkgs; [ libsecret nss mesa ];

  passthru.updateScript = ./update.sh;
  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/jagex-launcher.png \
      $out/share/pixmaps/jagex-launcher.png

    install -Dm644 ${appimageContents}/jagex-launcher.desktop \
      $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun %U' 'Exec=${pname} %U'
  '';

  meta = {
    description = "Official Jagex Launcher for RuneScape game clients";
    homepage = "https://www.runescape.com/";
    downloadPage =
      "https://rs-launcher-updates.runescape.com/production/linux/x64/latest/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "jagex-launcher";
    maintainers = with lib.maintainers; [ orbsa ];
    platforms = [ "x86_64-linux" ];
  };
}
