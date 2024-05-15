{ fetchFromGitHub
, fetchurl
, jre
, lib
, makeWrapper
, stdenvNoCC

, gamemodeSupport ? stdenvNoCC.isLinux
, textToSpeechSupport ? stdenvNoCC.isLinux
, additionalLibs ? [ ]

, # dependencies
  flite
, gamemode
, libglvnd
, libpulseaudio
, udev
, xorg
}:

let
  pname = "atlauncher";
  version = "3.4.36.9";

  srcs = [
    (fetchFromGitHub {
      owner = "ATLauncher";
      repo = "ATLauncher";
      rev = "v${version}";
      hash = "sha256-L3mGjxeyDtt7m7V2o81I99nRuBrINsPg4CbWfFqtoB0=";
    })
    (fetchurl {
      url = "https://github.com/ATLauncher/ATLauncher/releases/download/v${version}/ATLauncher-${version}.jar";
      hash = "sha256-7l4D99rTOP+oyaa+O8GPGugr3Nv8EIt6EqK1L9ttFBA=";
    })
  ];
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = builtins.elemAt srcs 1;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      runtimeLibraries = [
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

      install -D -m444 $src $out/share/java/ATLauncher.jar

      makeWrapper ${jre}/bin/java $out/bin/atlauncher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
        --add-flags "-jar $out/share/java/ATLauncher.jar" \
        --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
        --add-flags "--no-launcher-update"

      runHook postInstall
    '';

  postInstall = let packagingDir = "${builtins.elemAt srcs 0}/packaging/linux/_common"; in ''
    install -D -m444 ${packagingDir}/atlauncher.svg $out/share/icons/hicolor/scalable/apps/atlauncher.svg
    install -D -m444 ${packagingDir}/atlauncher.desktop $out/share/applications/atlauncher.desktop
  '';

  meta = {
    changelog = "https://github.com/ATLauncher/ATLauncher/blob/v${version}/CHANGELOG.md";
    description = "Simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com";
    license = lib.licenses.gpl3;
    mainProgram = "atlauncher";
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
