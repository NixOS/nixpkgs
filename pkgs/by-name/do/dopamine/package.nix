{
  lib,
  fetchurl,
  appimageTools,
  nix-update-script,
}:
appimageTools.wrapType2 rec {
  pname = "dopamine";
  version = "3.0.0-preview.37";

  src = fetchurl {
    url = "https://github.com/digimezzo/dopamine/releases/download/v${version}/Dopamine-${version}.AppImage";
    hash = "sha256-QmJRMI7BDnktx4bwcTSs823lDPdwR1trgUpbhG8D8hg=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm644 ${contents}/dopamine.desktop $out/share/applications/dopamine.desktop
      substituteInPlace $out/share/applications/dopamine.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=dopamine'
      cp -r ${contents}/usr/share/icons $out/share
    '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };

  meta = {
    changelog = "https://github.com/digimezzo/dopamine/blob/${version}/CHANGELOG.md";
    description = "Audio player that keeps it simple";
    homepage = "https://github.com/digimezzo/dopamine";
    license = lib.licenses.gpl3Only;
    mainProgram = "dopamine";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
