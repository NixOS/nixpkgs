{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  gradle,
  jdk17,
  jre,
  libxxf86vm,
  libGL,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "runelite";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "runelite";
    repo = "launcher";
    tag = finalAttrs.version;
    hash = "sha256-1IUjbZEvoHb2Fer16rIvi6shMsol+hiPLQleXHRVLEU=";
  };

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = "runelite";
    comment = "Open source Old School RuneScape client";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
    startupWMClass = "net-runelite-client-RuneLite";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17}" ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/share/icons
    mkdir -p $out/share/applications

    cp build/libs/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    ln -s ${finalAttrs.desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxxf86vm
          libGL
        ]
      }" \
      --add-flags "-jar $out/share/RuneLite.jar"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kmeakin
      moody
      iedame
    ];
    platforms = lib.platforms.linux;
    mainProgram = "runelite";
  };
})
