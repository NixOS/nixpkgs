{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "shadow-launcher";
  version = "9.9.10132";
  channel = "prod";
  src = fetchurl {
    url = "https://update.shadow.tech/launcher/${channel}/linux/ubuntu_18.04/ShadowPC-${version}.AppImage";
    hash = "sha256-evwt7S2jxyFq9Kmx4OvX4Kuabuq2fM2PWp3GI2YCe/c=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libinput
      libva
      xorg.libX11
      xorg.libXau
      xorg.libXdmcp
    ];

  meta = {
    description = "Shadow PC is a cloud platform designed to provide users with access to high-performance Windows machine for gaming, creative work, and business applications.";
    homepage = "https://shadow.tech/";
    license = lib.licenses.unfree;
    mainProgram = "shadow-launcher";
    maintainers = with lib.maintainers; [ jacfal ];
    platforms = [ "x86_64-linux" ];
  };
}
