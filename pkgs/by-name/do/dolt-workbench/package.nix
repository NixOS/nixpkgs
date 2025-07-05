{
  lib,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
}:
let
  pname = "dolt-workbench";
  version = "0.3.20";

  src = fetchurl {
    url = "https://github.com/dolthub/dolt-workbench/releases/download/v${version}/Dolt-Workbench-linux-x86_64.AppImage";
    hash = "sha256-Tgbg2wrfEwyZvdySj0/wlN4y4Pz/94boeCPk0OS34kA=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/dolt-workbench.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/dolt-workbench.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=dolt-workbench'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraBwrapArgs = [
    "--bind-try /etc/nixos/ /etc/nixos/"
  ];

  extraPkgs = pkgs: [
    pkgs.unzip
    pkgs.asar
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  # vscode likes to kill the parent so that the
  # gui application isn't attached to the terminal session
  dieWithParent = false;

  meta = {
    description = "Web-based UI for Dolt databases";
    homepage = "https://github.com/dolthub/dolt-workbench";
    license = lib.licenses.asl20; # Apache License 2.0
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ lapingvino ];
    mainProgram = "dolt-workbench";
  };
}
