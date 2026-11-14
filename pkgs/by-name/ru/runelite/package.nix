{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeWrapper,
  cmake,
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
    # native/{dropt,sajson} for the macOS launcher
    fetchSubmodules = true;
    hash = "sha256-obT2/n8RFz2TK0GHv4eD+VUann1Xa+JaHgYTtw1Gn4I=";
  };

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "RuneLite";
      type = "Application";
      exec = "runelite";
      icon = "runelite";
      comment = "Open source Old School RuneScape client";
      desktopName = "RuneLite";
      genericName = "Oldschool Runescape";
      categories = [ "Game" ];
      startupWMClass = "net-runelite-client-RuneLite";
    })
  ];

  # On macOS the launcher would try to replace its (read-only) app bundle with
  # a newer release
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/main/java/net/runelite/launcher/Updater.java \
      --replace-fail "var update = findAvailableUpdate(bootstrap);" "if (true) return; var update = findAvailableUpdate(bootstrap);"
  '';

  nativeBuildInputs = [
    gradle
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cmake ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # Java's dual-stack sockets prevent Gradle from connecting to its daemon
  # inside the Darwin sandbox.
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    JAVA_TOOL_OPTIONS = "-Djava.net.preferIPv4Stack=true";
  };
  # gradle's mitm-cache proxy and daemon listen on localhost
  __darwinAllowLocalNetworking = true;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk17}"
    # Without it, the RuneLite splash, icon and runelite.net links are left
    # out of launcher.properties, as for upstream's unofficial builds.
    "-PRUNELITE_BUILD=runelite"
  ];

  # filterOsx renders osx/Info.plist for the app bundle
  gradleBuildTask = "shadowJar" + lib.optionalString stdenv.hostPlatform.isDarwin " filterOsx";

  # cmake only builds the macOS native launcher (packr), see postBuild
  dontUseCmakeConfigure = true;

  # Upstream's macOS launcher runs the JVM inside the app bundle's process and
  # relaunches itself for the client, so both get the RuneLite name and icon.
  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cmake -S native -B native/build -DCMAKE_BUILD_TYPE=Release -DJAVA_HOME=${jdk17.home}
    cmake --build native/build
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    mkdir -p $out/share/applications

    cp build/libs/RuneLite.jar $out/share
    cp appimage/runelite.png $out/share/icons

    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libxxf86vm
          libGL
        ]
      }" \
      --add-flags "-jar $out/share/RuneLite.jar"
  ''
  # Same layout as upstream's build-osx-*.sh, with the JRE symlinked in
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    app=$out/Applications/RuneLite.app/Contents
    mkdir -p $app/MacOS $app/Resources $out/bin

    install -Dm755 native/build/src/RuneLite $app/MacOS/RuneLite
    cp build/filtered-resources/Info.plist $app
    cp build/libs/RuneLite.jar $app/Resources
    cp packr/macos-aarch64-config.json $app/Resources/config.json
    cp osx/runelite.icns $app/Resources/icons.icns
    ln -s ${jre.home} $app/Resources/jre

    # not a symlink: the launcher finds config.json via its own path
    makeWrapper $app/MacOS/RuneLite $out/bin/runelite
  ''
  + ''
    runHook postInstall
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "runelite";
  };
})
