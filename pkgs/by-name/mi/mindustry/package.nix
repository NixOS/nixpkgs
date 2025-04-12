{
  lib,
  stdenv,
  fetchpatch,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  fetchFromGitHub,
  gradle_8,
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
  version = "146";
  buildVersion = makeBuildVersion version;

  jdk = jdk17;
  # "Deprecated Gradle features were used in this build, making it incompatible with Gradle 9.0."
  gradle = gradle_8;

  Mindustry = fetchFromGitHub {
    owner = "Anuken";
    repo = "Mindustry";
    rev = "v${version}";
    hash = "sha256-pJAJjb8rgDL5q2hfuXH2Cyb1Szu4GixeXoLMdnIAlno=";
  };
  Arc = fetchFromGitHub {
    owner = "Anuken";
    repo = "Arc";
    rev = "v${version}";
    hash = "sha256-L+5fshI1oo1lVdTMTBuPzqtEeR2dq1NORP84rZ83rT0=";
  };
  soloud = fetchFromGitHub {
    owner = "Anuken";
    repo = "soloud";
    # This is pinned in Arc's arc-core/build.gradle
    rev = "v0.9";
    hash = "sha256-6KlqOtA19MxeqZttNyNrMU7pKqzlNiA4rBZKp9ekanc=";
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
    # Fix build with gradle 8.8, remove on next Arc release
    (fetchpatch {
      url = "https://github.com/Anuken/Arc/commit/2a91c51bf45d700091e397fd0b62384763901ae6.patch";
      hash = "sha256-sSD78GmF14vBvNe+ajUJ4uIc4p857shTP/UkAK6Pyyg=";
      extraPrefix = "Arc/";
      stripLen = 1;
    })
    (fetchpatch {
      url = "https://github.com/Anuken/Arc/commit/d7f8ea858c425410dbd43374271a703d4443b432.patch";
      hash = "sha256-5LPgBOV0r/dUtpyxitTu3/9tMIqjeIKfGVJi3MEr7fQ=";
      extraPrefix = "Arc/";
      stripLen = 1;
    })
    (fetchpatch {
      url = "https://github.com/Anuken/Mindustry/commit/695dad201fb4c2b4252f2ee5abde32e968169ba5.patch";
      hash = "sha256-bbTjyfUl+XFG/dgD1XPddVKD/ImOP5ARAP3q0FPnt58=";
      name = "always-use-local-arc-1.patch";
      stripLen = 1;
      extraPrefix = "Mindustry/";
    })
    (fetchpatch {
      url = "https://github.com/Anuken/Mindustry/commit/f6082225e859c759c8d9c944250b6ecd490151ed.patch";
      hash = "sha256-xFHdAUTS1EiHNQqw6qfzYk2LMr/DjeHoEzQfcfOUcFs=";
      name = "always-use-local-arc-2.patch";
      stripLen = 1;
      extraPrefix = "Mindustry/";
    })
    (fetchpatch {
      url = "https://github.com/Anuken/Mindustry/commit/e4eadbbb7f35db3093a0a3d13272bdfbedfaead3.patch";
      hash = "sha256-L/XQAxh6UgKsTVTgQKDXNRIAdtVtaY4ameT/Yb/+1p8=";
      name = "always-use-local-arc-3.patch";
      stripLen = 1;
      extraPrefix = "Mindustry/";
    })
  ];

  postPatch =
    ''
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
  nativeBuildInputs =
    [
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

  buildPhase =
    ''
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
    broken = enableClient && stdenv.hostPlatform.isDarwin;
  };
}
