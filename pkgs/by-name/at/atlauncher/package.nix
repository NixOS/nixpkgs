{
  fetchFromGitHub,
  gradle_8,
  jre,
  lib,
  makeWrapper,
  stdenvNoCC,

  gamemodeSupport ? stdenvNoCC.hostPlatform.isLinux,
  textToSpeechSupport ? stdenvNoCC.hostPlatform.isLinux,
  additionalLibs ? [ ],

  # dependencies
  flite,
  gamemode,
  libglvnd,
  libpulseaudio,
  udev,
  xorg,
}:
let
  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "atlauncher";
  version = "3.4.38.2";

  src = fetchFromGitHub {
    owner = "ATLauncher";
    repo = "ATLauncher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x8ch8BdUckweuwEvsOxYG2M5UmbW4fRjF/jJ6feIjIA=";
  };

  postPatch = ''
    # exclude UI tests
    sed -i "/test {/a\    exclude '**/BasicLauncherUiTest.class'" build.gradle
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  doCheck = true;

  gradleBuildTask = "shadowJar";

  gradleFlags = [
    "--exclude-task"
    "createExe"
  ];

  installPhase =
    let
      runtimeLibraries = [
        libglvnd
        libpulseaudio
        udev
        xorg.libX11
        xorg.libXcursor
        xorg.libXxf86vm
      ]
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ lib.optional textToSpeechSupport flite
      ++ additionalLibs;
    in
    ''
      runHook preInstall

      mkdir -p $out/{bin,share/java}
      cp build/libs/ATLauncher-${finalAttrs.version}.jar $out/share/java/ATLauncher.jar

      makeWrapper ${lib.getExe jre} $out/bin/atlauncher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibraries}" \
        --add-flags "-jar $out/share/java/ATLauncher.jar" \
        --add-flags "--working-dir \"\''${XDG_DATA_HOME:-\$HOME/.local/share}/ATLauncher\"" \
        --add-flags "--no-launcher-update"

      runHook postInstall
    '';

  postInstall =
    let
      packagingDir = "${finalAttrs.src}/packaging/linux/_common";
    in
    ''
      install -D -m444 ${packagingDir}/atlauncher.desktop -t $out/share/applications
      install -D -m444 ${packagingDir}/atlauncher.metainfo.xml -t $out/share/metainfo
      install -D -m444 ${packagingDir}/atlauncher.png -t $out/share/pixmaps
      install -D -m444 ${packagingDir}/atlauncher.svg -t $out/share/icons/hicolor/scalable/apps
    '';

  meta = {
    broken = stdenvNoCC.hostPlatform.isDarwin; # https://github.com/NixOS/nixpkgs/issues/356259
    changelog = "https://github.com/ATLauncher/ATLauncher/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Simple and easy to use Minecraft launcher which contains many different modpacks for you to choose from and play";
    downloadPage = "https://atlauncher.com/downloads";
    homepage = "https://atlauncher.com";
    license = lib.licenses.gpl3;
    mainProgram = "atlauncher";
    maintainers = with lib.maintainers; [ getpsyched ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
