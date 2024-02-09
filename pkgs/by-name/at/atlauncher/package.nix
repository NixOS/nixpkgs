{ copyDesktopItems
, fetchFromGitHub
, fetchurl
, lib
, makeDesktopItem
, makeWrapper
, stdenvNoCC

, # dependencies
  jre
, udev
, xorg
}:

let
  pname = "atlauncher";
  version = "3.4.35.9";

  srcs = {
    source = (fetchFromGitHub {
      owner = "ATLauncher";
      repo = "ATLauncher";
      rev = "v${version}";
      hash = "sha256-QbSCerrALrbHMWuPgJEthUrcYlaDEWuU6Kzwqe2mr8Q=";
    });
    jar = (fetchurl {
      url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${version}/ATLauncher-${version}.jar";
      hash = "sha256-Y2MGhzq4IbtjEG+CER+FWU8CY+hn5ehjMOcP02zIsR4=";
    });
  };

  packagingDir = "${srcs.source}/packaging/linux/_common";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = srcs.jar;
  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D -m 444 $src $out/share/java/ATLauncher.jar

    makeWrapper ${jre}/bin/java $out/bin/atlauncher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm udev ]}" \
      --add-flags "-jar $out/share/java/ATLauncher.jar" \
      --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
      --add-flags "--no-launcher-update"

    runHook postInstall
  '';

  postInstall = ''
    install -D -m 644 ${packagingDir}/atlauncher.svg $out/share/icons/hicolor/scalable/apps/atlauncher.svg
  '';

  desktopItems = [ "${packagingDir}/atlauncher.desktop" ];

  meta = with lib; {
    changelog = "https://github.com/ATLauncher/ATLauncher/blob/v${version}/CHANGELOG.md";
    description = "A simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com";
    license = licenses.gpl3;
    mainProgram = "atlauncher";
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.all;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
  };
}
