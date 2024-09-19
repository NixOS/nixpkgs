{
  stdenvNoCC,
  lib,
  appimageTools,
  fetchurl,
  writers,
}:

let
  pname = "librewolf-bin";
  info = builtins.fromJSON (builtins.readFile ./info.json);
  system = stdenvNoCC.hostPlatform.system;
  src = fetchurl (info.${system});
  version = info.version;
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraInstallCommands = ''
    mv $out/bin/{${pname},librewolf}
    install -Dm444 ${appimageContents}/io.gitlab.LibreWolf.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/librewolf.png -t $out/share/pixmaps
  '';

  passthru.updateScript = writers.writePython3 "librewolf-bin-update" { flakeIgnore = [ "E501" ]; } (
    builtins.readFile ./update.py
  );

  meta = {
    description = "Fork of Firefox, focused on privacy, security and freedom (upstream AppImage release)";
    homepage = "https://librewolf.net";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ squalus ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "librewolf";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
