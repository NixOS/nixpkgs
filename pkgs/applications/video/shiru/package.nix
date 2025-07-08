{
  lib,
  fetchurl,
  appimageTools,
  nix-update-script,
}:

let
  pname = "shiru";
  tag = "6.1.4";

  src = fetchurl {
    url = "https://github.com/RockinChaos/Shiru/releases/download/v${tag}/linux-Shiru-v${tag}.AppImage";
    hash = "sha256-lgJd5RDZGXys+DPf7mWJ2L7/Ei14/xwVjZYTKOod52A=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname tag src; };

in
appimageTools.wrapType2 {
  inherit pname tag src;

  extraInstallCommands = ''
    # Copy desktop entry
    mkdir -p $out/share/applications
    cp ${appimageContents}/shiru.desktop $out/share/applications/

    # Copy icon
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp ${appimageContents}/shiru.png $out/share/icons/hicolor/512x512/apps/

    # Fix desktop entry
    substituteInPlace $out/share/applications/shiru.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "BitTorrent streaming software with no paws in the way—watch anime in real-time, no waiting for downloads";
    longDescription = ''
      Shiru is a fork of Miru v5.5.10 that enhances the anime streaming experience 
      with a feature-rich environment and full mobile support. It blends the power 
      of BitTorrent streaming with the convenience of traditional streaming platforms.

      Features include:
      - Anime integration with AniList & MyAnimeList
      - Full subtitle support with softcoded and external files
      - Seamless video controls and keyboard shortcuts
      - Torrent streaming in real-time
      - Discord Rich Presence integration
      - Picture-in-Picture mode
    '';
    homepage = "https://github.com/RockinChaos/Shiru";
    changelog = "https://github.com/RockinChaos/Shiru/releases/tag/v${tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.qxrein ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "shiru";
  };
}
