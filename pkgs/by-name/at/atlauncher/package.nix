{ copyDesktopItems, fetchurl, jre, lib, makeDesktopItem, makeWrapper, stdenv, udev, xorg }:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.35.9";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-Y2MGhzq4IbtjEG+CER+FWU8CY+hn5ehjMOcP02zIsR4=";
  };

  env.ICON = fetchurl {
    url = "https://atlauncher.com/assets/images/logo.svg";
    hash = "sha256-XoqpsgLmkpa2SdjZvPkgg6BUJulIBIeu6mBsJJCixfo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp $src $out/share/java/ATLauncher.jar

    makeWrapper ${jre}/bin/java $out/bin/atlauncher \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ xorg.libXxf86vm udev ]}" \
      --add-flags "-jar $out/share/java/ATLauncher.jar" \
      --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
      --add-flags "--no-launcher-update"

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $ICON $out/share/icons/hicolor/scalable/apps/atlauncher.svg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      categories = [ "Game" ];
      desktopName = "ATLauncher";
      exec = "atlauncher";
      icon = "atlauncher";
      name = "atlauncher";
    })
  ];

  meta = with lib; {
    description = "A simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com";
    license = licenses.gpl3;
    mainProgram = "atlauncher";
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.all;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
  };
})
