{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  gradle,
  jdk17,
  zenity,

  # for arc
  SDL2,
  pkg-config,
  ant,
  curl,
  wget,
  alsa-lib,
  alsa-plugins,
  glew,

  # for soloud
  libpulseaudio ? null,
  libjack2 ? null,

  nixosTests,

  # Make the build version easily overridable.
  # Server and client build versions must match, and an empty build version means
  # any build is allowed, so this parameter acts as a simple whitelist.
  # Takes the package version and returns the build version.
  makeBuildVersion ? (v: v),
  enableClient ? true,
  enableServer ? true,

  enableWayland ? false,
}:

let
  pname = "mindustry";
  version = "151.1";
  buildVersion = makeBuildVersion version;

  jdk = jdk17;

  Mindustry = fetchFromGitHub {
    name = "Mindustry-source";
    owner = "Anuken";
    repo = "Mindustry";
    tag = "v${version}";
    hash = "sha256-/WBO66Ii/1IuL3VaQNCTrcK43VWS8FVLYPxxtJMYKus=";
  };
  Arc = fetchFromGitHub {
    name = "Arc-source";
    owner = "Anuken";
    repo = "Arc";
    tag = "v${version}";
    hash = "sha256-jI9bvo8MEEe1guM8YuQmGOi/wP5eFH88dvsin7sAPY0=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # This is pinned in Arc's arc-core/build.gradle
    tag = "v0.11";
    hash = "sha256-jybIILdK3cqyZ2LIuoWDfZWocVTbKszekKCLil0WXRY=";
  };

  desktopItem = makeDesktopItem {
    name = "Mindustry";
    desktopName = "Mindustry";
    exec = "mindustry";
    icon = "mindustry";
    categories = [ "Game" ];
  };

in
assert lib.assertMsg (
  enableClient || enableServer
) "mindustry: at least one of 'enableClient' and 'enableServer' must be true";
stdenv.mkDerivation {
  inherit pname version;

  unpackPhase = ''
    runHook preUnpack

    cp -r ${Mindustry} Mindustry
    cp -r ${Arc} Arc
    chmod -R u+w -- Mindustry Arc
    cp -r ${soloud} Arc/arc-core/csrc/soloud
    chmod -R u+w -- Arc/arc-core/csrc/soloud

    runHook postUnpack
  '';

  patches = [
    ./0001-fix-include-path-for-SDL2-on-linux.patch
  ];

  postPatch = ''
    # Ensure the prebuilt shared objects don't accidentally get shipped
    rm -r Arc/natives/natives-*/libs/*
    rm -r Arc/backends/backend-*/libs/*

    cd Mindustry

    # Remove unbuildable iOS stuff
    sed -i '/^project(":ios"){/,/^}/d' build.gradle
    sed -i '/robo(vm|VM)/d' build.gradle
    rm ios/build.gradle
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86) ''
    substituteInPlace ../Arc/arc-core/build.gradle \
      --replace-fail "-msse" ""
    substituteInPlace ../Arc/backends/backend-sdl/build.gradle \
      --replace-fail "-m64" ""
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  buildInputs = lib.optionals enableClient [
    SDL2
    alsa-lib
    glew
  ];
  nativeBuildInputs = [
    pkg-config
    gradle
    makeWrapper
    jdk
  ]
  ++ lib.optionals enableClient [
    ant
    copyDesktopItems
    curl
    wget
  ];

  desktopItems = lib.optional enableClient desktopItem;

  gradleFlags = [
    "-Pbuildversion=${buildVersion}"
    "-Dorg.gradle.java.home=${jdk}"
  ];

  buildPhase = ''
    runHook preBuild
  ''
  + lib.optionalString enableServer ''
    gradle server:dist
  ''
  + lib.optionalString enableClient ''
    pushd ../Arc
    gradle jnigenBuild
    gradle jnigenJarNativesDesktop
    glewlib=${lib.getLib glew}/lib/libGLEW.so
    sdllib=${lib.getLib SDL2}/lib/libSDL2.so
    patchelf backends/backend-sdl/libs/linux64/libsdl-arc*.so \
      --add-needed $glewlib \
      --add-needed $sdllib
    # Put the freshly-built libraries where the pre-built libraries used to be:
    cp arc-core/libs/*/* natives/natives-desktop/libs/
    cp extensions/freetype/libs/*/* natives/natives-freetype-desktop/libs/
    popd

    gradle desktop:dist
  ''
  + ''
    runHook postBuild
  '';

  installPhase =
    let
      installClient = ''
        install -Dm644 desktop/build/libs/Mindustry.jar $out/share/mindustry.jar
        mkdir -p $out/bin
        makeWrapper ${jdk}/bin/java $out/bin/mindustry \
          --add-flags "-jar $out/share/mindustry.jar" \
          ${lib.optionalString stdenv.hostPlatform.isLinux "--suffix PATH : ${lib.makeBinPath [ zenity ]}"} \
          --suffix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              libpulseaudio
              alsa-lib
              libjack2
            ]
          } \
          --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib/ ${lib.optionalString enableWayland ''
            --set SDL_VIDEODRIVER wayland \
            --set SDL_VIDEO_WAYLAND_WMCLASS Mindustry
          ''}

        # Retain runtime depends to prevent them from being cleaned up.
        # Since a jar is a compressed archive, nix can't figure out that the dependency is actually in there,
        # and will assume that it's not actually needed.
        # This can cause issues.
        # See https://github.com/NixOS/nixpkgs/issues/109798.
        echo "# Retained runtime dependencies: " >> $out/bin/mindustry
        for dep in ${SDL2.out} ${alsa-lib.out} ${glew.out}; do
          echo "# $dep" >> $out/bin/mindustry
        done

        install -Dm644 core/assets/icons/icon_64.png $out/share/icons/hicolor/64x64/apps/mindustry.png
      '';
      installServer = ''
        install -Dm644 server/build/libs/server-release.jar $out/share/mindustry-server.jar
        mkdir -p $out/bin
        makeWrapper ${jdk}/bin/java $out/bin/mindustry-server \
          --add-flags "-jar $out/share/mindustry-server.jar"
      '';
    in
    ''
      runHook preInstall
    ''
    + lib.optionalString enableClient installClient
    + lib.optionalString enableServer installServer
    + ''
      runHook postInstall
    '';

  postGradleUpdate = ''
    # this fetches non-gradle dependencies
    cd ../Arc
    gradle preJni
  '';

  passthru.tests.nixosTest = nixosTests.mindustry;

  meta = {
    homepage = "https://mindustrygame.github.io/";
    downloadPage = "https://github.com/Anuken/Mindustry/releases";
    description = "Sandbox tower defense game";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      chkno
      fgaz
      thekostins
    ];
    platforms = lib.platforms.all;
    # TODO alsa-lib is linux-only, figure out what dependencies are required on Darwin
    broken =
      enableClient
      && (stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64));
  };
}
