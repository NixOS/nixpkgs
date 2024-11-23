{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle,
  jre,
  makeWrapper,
  jdk,
  git,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quake-injector";
  version = "06";

  src = fetchFromGitHub {
    owner = "hrehfeld";
    repo = "QuakeInjector";
    rev = "refs/tags/alpha${finalAttrs.version}";
    hash = "sha256-bbvLp5/Grg+mXBuV5aJCMOSjFp1+ukZS+AivcbhBxHU=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
    git
    copyDesktopItems
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/quake-injector}
    cp build/libs/QuakeInjector.jar $out/share/quake-injector

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp src/main/resources/Inject2_256.png $out/share/icons/hicolor/256x256/apps/quake-injector.png

    makeWrapper ${jre}/bin/java $out/bin/quake-injector \
      --add-flags "-jar $out/share/quake-injector/QuakeInjector.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "quake-injector";
      exec = finalAttrs.meta.mainProgram;
      icon = "quake-injector";
      comment = finalAttrs.meta.description;
      desktopName = "Quake Injector";
      categories = [ "Game" ];
    })
  ];

  meta = {
    description = "Download, install and play quake singleplayer maps from the quaddicted.com archive";
    homepage = "https://github.com/hrehfeld/QuakeInjector";
    changelog = "https://github.com/hrehfeld/QuakeInjector/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "quake-injector";
    platforms = jdk.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
