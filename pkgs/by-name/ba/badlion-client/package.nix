{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}:

appimageTools.wrapAppImage rec {
  pname = "badlion-client";
  version = "4.5.4";

  src = appimageTools.extractType2 {
    inherit pname version;
    src = fetchurl {
      name = "badlion-client-linux";
      # https://www.badlion.net/download/client/latest/linux
      url = "https://web.archive.org/web/20250416011033/https://client-updates.badlion.net/BadlionClient";
      hash = "sha256-M2aG3vb1EBpvx8ODs67Ua1R7lBXSe2oIcSwFzSz91n4=";
    };
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -Dm444 ${src}/BadlionClient.desktop $out/share/applications/BadlionClient.desktop
    install -Dm444 ${src}/BadlionClient.png $out/share/pixmaps/BadlionClient.png
    substituteInPlace $out/share/applications/BadlionClient.desktop \
      --replace-fail "Exec=AppRun --no-sandbox %U" "Exec=badlion-client"
    wrapProgram $out/bin/badlion-client \
      --set APPIMAGE 1
  '';

  extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];

  meta = {
    description = "Most Complete All-In-One Mod Library for Minecraft with 100+ Mods, FPS Improvements, and more";
    homepage = "https://client.badlion.net";
    license = lib.licenses.unfree;
    maintainers = [ ];
    mainProgram = "badlion-client";
    platforms = [ "x86_64-linux" ];
  };
}
