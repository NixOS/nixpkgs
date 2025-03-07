{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "sozi";
  version = "23.7.25-1690311612";

  src = fetchurl {
    url = "https://github.com/sozi-projects/Sozi/releases/download/v23.07/Sozi-${version}.AppImage";
    hash = "sha256-QHvgevv60ZTkkdt+IWaCuXt0XVnhe5Q5oROwa2LFie8=";
  };

  appimageContents = appimageTools.extract {
    inherit version pname src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs =
    pkgs: with pkgs; [
      polkit
      udev
    ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/sozi.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/sozi.desktop \
      --replace 'Exec=AppRun' 'Exec=sozi'
  '';

  meta = {
    description = "Zooming presentation editor and player";
    homepage = "https://sozi.baierouge.fr/";
    license = lib.licenses.mpl20;
    mainProgram = "sozi";
    maintainers = with lib.maintainers; [ srghma ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
