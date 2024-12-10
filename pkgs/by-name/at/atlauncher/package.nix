{
  copyDesktopItems,
  fetchurl,
  jre,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenv,

  gamemodeSupport ? stdenv.isLinux,
  textToSpeechSupport ? stdenv.isLinux,
  additionalLibs ? [ ],

  # dependencies
  flite,
  gamemode,
  libglvnd,
  libpulseaudio,
  udev,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.36.4";

  src = fetchurl {
    url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${finalAttrs.version}/ATLauncher-${finalAttrs.version}.jar";
    hash = "sha256-7l4D99rTOP+oyaa+O8GPGugr3Nv8EIt6EqK1L9ttFBA=";
  };

  env.ICON = fetchurl {
    url = "https://atlauncher.com/assets/images/logo.svg";
    hash = "sha256-XoqpsgLmkpa2SdjZvPkgg6BUJulIBIeu6mBsJJCixfo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  installPhase =
    let
      runtimeLibraries =
        [
          libglvnd
          libpulseaudio
          udev
          xorg.libXxf86vm
        ]
        ++ lib.optional gamemodeSupport gamemode.lib
        ++ lib.optional textToSpeechSupport flite
        ++ additionalLibs;
    in
    ''
      runHook preInstall

      mkdir -p $out/bin $out/share/java
      cp $src $out/share/java/ATLauncher.jar

      makeWrapper ${jre}/bin/java $out/bin/atlauncher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
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
