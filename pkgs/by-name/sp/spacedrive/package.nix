{ lib, appimageTools, fetchurl, pkgs }:

let
  pname = "spacedrive";
  version = "0.1.4";

  src = fetchurl {
    url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.AppImage";
    hash = "sha256-iBdW8iPuvztP0L5xLyVs7/K8yFe7kD7QwdTuKJLhB+c=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs:
    (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libthai ];

  extraInstallCommands = ''
    # Remove version from entrypoint
    mv $out/bin/spacedrive-"${version}" $out/bin/spacedrive

    # Install .desktop files
    install -Dm444 ${appimageContents}/spacedrive.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/spacedrive.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/spacedrive.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=spacedrive'
  '';

  meta = with lib; {
    description = "An open source file manager, powered by a virtual distributed filesystem";
    homepage = "https://www.spacedrive.com/";
    platforms = [ "x86_64-linux" ];
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ mikaelfangel heisfer ];
    mainProgram = "spacedrive";
  };
}
