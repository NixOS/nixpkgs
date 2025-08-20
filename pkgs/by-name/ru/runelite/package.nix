{
  lib,
  stdenv,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  gradle,
  jdk17,
  jre,
  xorg,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "runelite";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "runelite";
    repo = "launcher";
    rev = version;
    hash = "sha256-HZ4aV+7173EZrHHbsEFsrh3BHXsZuWS/MvDBS/AYANY=";
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
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dorg.gradle.java.home=${jdk17}" ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/share/icons
    mkdir -p $out/share/applications

    cp build/libs/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    ln -s ${desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          xorg.libXxf86vm
          libGL
        ]
      }" \
      --add-flags "-jar $out/share/RuneLite.jar"
  '';

  passthru.updateScript =
    let
      pkg = finalAttrs.finalPackage;
    in
    gradle.fetchDeps
      {
        inherit (finalAttrs) pname;
        inherit pkg;
        data = ./deps.json;
      }
      .updateScript;

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
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "runelite";
  };
})
