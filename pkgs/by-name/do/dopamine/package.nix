{
  lib,
  fetchurl,
  appimageTools,
  nix-update-script,
  makeWrapper,
}:
appimageTools.wrapType2 rec {
  pname = "dopamine";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/digimezzo/dopamine/releases/download/v${version}/Dopamine-${version}.AppImage";
    hash = "sha256-kvXan5J+rxJ/ugcEz9xytq3eQG0saWrYZjF7O1d6rTA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

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
    maintainers = with lib.maintainers; [
      Guanran928
      ern775
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
