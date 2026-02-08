{
  fetchFromGitHub,
  openjdk21,
  lib,
  stdenvNoCC,

  gradle_8,
  makeWrapper,
  glibcLocales,
  breakpointHook,

  flite,
  libGL,
  libusb1,
  libpulseaudio,
  udev,

  enableController ? stdenvNoCC.hostPlatform.isLinux,
  enableTextToSpeech ? stdenvNoCC.hostPlatform.isLinux,
}:

let
  gradle = gradle_8;
  openjdk = openjdk21.override { enableJavaFX = true; };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "legacy-launcher";
  version = "1.169.1";

  src = fetchFromGitHub {
    owner = "LegacyLauncher";
    repo = "archive";
    rev = "631ca936343768b857cf6ecb9e536585fee1b88b";
    hash = "sha256-+mqc68d02E95IUC5Q6bBNkgdOIOZjHZa5iGB948H4HA=";
  };

  patches = [ ./remove-auto-version.patch ];

  nativeBuildInputs = [
    gradle
    makeWrapper
    breakpointHook
  ];
  buildInputs = [ glibcLocales ];
  env.LANG = "C.UTF-8";
  env.LC_ALL = "C.UTF-8";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleBuildFlags = [
    "-Dtlauncher.bootstrap.targetJar=${placeholder "out"}/share/java/launcher.jar"
    "-Dtlauncher.bootstrap.targetLibFolder=${placeholder "out"}/share/bootstrap/launcherLibs"
    "-Dtlauncher.bootstrap.ignoreUpdate=true"
    "-Dtlauncher.bootstrap.ignoreSelfUpdate=true"
  ];

  postBuild = ''
    gradle :bootstrap:collectLauncherLibsRepo --no-daemon
  '';

  installPhase =
    let
      bootstrapVersion = "1.40.3"; # bootstrap/gradle.properties
      runtimeLibs = [
        libGL # glfw
        libpulseaudio # openal
        udev # oshi
      ]
      ++ lib.optional enableController libusb1
      ++ lib.optional enableTextToSpeech flite.lib;
    in
    ''
      runHook preInstall

      install -DT -m644 ./launcher/build/libs/launcher-${finalAttrs.version}.jar "$out"/share/java/launcher.jar
      install -DT -m644 ./bootstrap/build/libs/bootstrap-${bootstrapVersion}.jar "$out"/share/bootstrap/bootstrap.jar
      cp -r ./bootstrap/build/launcherLibs "$out"/share/bootstrap/

      makeWrapper ${lib.getExe openjdk} $out/bin/legacylauncher \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
        --add-flags "-jar $out/share/bootstrap/bootstrap.jar" \
        --add-flags "--java-executable ${lib.getExe openjdk}"

      runHook postInstall
    '';

  meta = {
    description = "Stable, fast and simple Minecraft Launcher";
    homepage = "https://llaun.ch";
    mainProgram = "legacylauncher";
    maintainers = with lib.maintainers; [ getpsyched ];
  };
})
