{ lib, stdenv, fetchurl, appimageTools, makeDesktopItem }:

let
  pname = "advantagescope";
  version = "3.2.0";

  desktopItem = makeDesktopItem {
    type = "Application";
    name = "AdvantageScope";
    desktopName = "AdvantageScope";
    comment = "Robot telemetry viewer for FIRST Robotics Competition teams";
    icon = "advantagescope";
    exec = "advantagescope %u";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/Mechanical-Advantage/AdvantageScope/v${version}/icons/window-icon.png";
    hash = "sha256-gqcCqthqM2g4sylg9zictKwRggbaALQk9ln/NaFHxdY=";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage";
      hash = "sha256-VLHcJVRYdAf1TEGmKvSJKauJwnUvHNG67WhX1rj8rKk=";
    };

    aarch64-linux = fetchurl {
      url = "https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-arm64-v${version}.AppImage";
      hash = "sha256-FAhJr8PFDhkR03WWT/FvIAJhrnR2tcBWCv8NqrPL7oM=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
    install -D "${desktopItem}/share/applications/"* -t $out/share/applications/
    install -D ${icon} $out/share/pixmaps/advantagescope.png
  '';

  meta = with lib; {
    description = "Robot telemetry viewer for FIRST Robotics Competition teams";
    homepage = "https://github.com/Mechanical-Advantage/AdvantageScope";
    license = licenses.mit;
    mainProgram = "advantagescope";
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ max-niederman ];
  };
}
