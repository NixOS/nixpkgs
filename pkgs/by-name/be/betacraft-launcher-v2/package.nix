{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  curl,
  json_c,
  libarchive,
  jdk8,
  jdk17,
  jdk21,
  makeWrapper,
  makeShellWrapper,
  nix-update-script,
  desktopToDarwinBundle,
  jq,
  gnused,
  writeShellScript,

  glfw3-minecraft,
  glib,
  libGL,
  openal,
  libglvnd,
  alsa-lib,
  libpulseaudio,
  libx11,
  libxxf86vm,
  libxext,
  libxcursor,
  libxrandr,
  libxtst,
  xrandr,
  udev,

  minecraftJdks ? [
    jdk8
    jdk17
    jdk21
  ],

  # Injected at build time for official Betacraft releases; empty in upstream git.
  microsoftClientId ? "8075fa74-4091-4356-a0b8-a7c118ef121c",
  discordClientId ? 0,
}:
let
  version = "2.0.0-alpha.20230623";

  javaBin = jdk: "${lib.getBin jdk}/bin/java";

  javaSyncScript = writeShellScript "betacraft-launcher-v2-sync-java" ''
    set -euo pipefail

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      settingsDir="$HOME/Library/Application Support/betacraft"
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      settingsDir="$HOME/.local/share/betacraft"
    ''}

    settingsFile="$settingsDir/settings.json"
    accountsFile="$settingsDir/accounts.json"
    mkdir -p "$settingsDir"

    if [ ! -f "$settingsFile" ]; then
      echo '{}' > "$settingsFile"
    fi

    if [ ! -f "$accountsFile" ]; then
      echo '{"selected":"","accounts":[]}' > "$accountsFile"
    fi

    java_version() {
      "$1" -version 2>&1 | head -n1 | ${gnused}/bin/sed -n 's/.*"\([^"]*\)".*/\1/p'
    }

    settings="$(${jq}/bin/jq -c . "$settingsFile")"

    for java in ${lib.concatStringsSep " " (map javaBin minecraftJdks)}; do
      [ -x "$java" ] || continue
      version="$(java_version "$java")"
      [ -n "$version" ] || continue
      settings="$(${jq}/bin/jq -c --arg path "$java" --arg version "$version" '
        .java //= {"selected":"","installations":[]}
        | .java.installations //= []
        | if (.java.installations | map(.path) | index($path)) then
            .java.installations = [.java.installations[] |
              if .path == $path then .version = $version else . end]
          else
            .java.installations += [{"version": $version, "path": $path}]
          end
      ' <<< "$settings")"
    done

    settings="$(${jq}/bin/jq -c '
      .java //= {"selected":"","installations":[]}
      | .java.installations = [.java.installations[] | select(.path != "/usr/bin/java")]
    ' <<< "$settings")"

    settings="$(${jq}/bin/jq -c --arg jdk8 "${javaBin jdk8}" '
      if (.java.selected // "") == "" or .java.selected == "/usr/bin/java" then
        .java.selected = $jdk8
      else .
      end
    ' <<< "$settings")"

    printf '%s\n' "$settings" > "$settingsFile"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "betacraft-launcher-v2";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "betacraftuk";
    repo = "betacraft-launcher";
    rev = finalAttrs.version;
    hash = "sha256-RygYJnj6foKyV40hrHhhv4kncFXTw2YwfOfBcgcIxg0=";
  };

  patches = [ ./auth-minimal.patch ];

  postPatch = ''
        cat > src/core/Constants.h <<EOF
    #ifndef BC_CONSTANTS_H
    #define BC_CONSTANTS_H

    #define API_MICROSOFT_CLIENT_ID "${microsoftClientId}"
    #define DISCORD_CLIENT_ID ${toString discordClientId}

    #endif
    EOF

        ${lib.optionalString stdenv.hostPlatform.isDarwin ''
          substituteInPlace CMakeLists.txt \
            --replace-fail 'set(CMAKE_OSX_ARCHITECTURES "x86_64")' \
            'set(CMAKE_OSX_ARCHITECTURES "arm64")' \
            --replace-fail 'set(CMAKE_APPLE_SILICON_PROCESSOR "x86_64")' \
            'set(CMAKE_APPLE_SILICON_PROCESSOR "arm64")'

          substituteInPlace src/core/CMakeLists.txt \
            --replace-fail 'set(CMAKE_APPLE_SILICON_PROCESSOR "x86_64")' \
            'set(CMAKE_APPLE_SILICON_PROCESSOR "arm64")'
        ''}

        substituteInPlace src/core/CMakeLists.txt \
          --replace-fail 'find_package(json-c CONFIG REQUIRED)' \
          'find_package(PkgConfig REQUIRED)' \
          --replace-fail 'find_package(CURL CONFIG REQUIRED)' \
          'find_package(CURL REQUIRED)'

        sed -i '/find_package(PkgConfig REQUIRED)/a\
    pkg_check_modules(JSON_C REQUIRED json-c)
    ' src/core/CMakeLists.txt

        sed -i 's/CURL::libcurl/''${CURL_LIBRARIES}/g' src/core/CMakeLists.txt
        sed -i 's/json-c::json-c/''${JSON_C_LIBRARIES}/g' src/core/CMakeLists.txt
        sed -i 's/target_include_directories(Core PUBLIC ''${LibArchive_INCLUDE_DIRS})/target_include_directories(Core PUBLIC ''${LibArchive_INCLUDE_DIRS} ''${JSON_C_INCLUDE_DIRS} ''${CURL_INCLUDE_DIRS})/' src/core/CMakeLists.txt

        # macOS /usr/bin/java is an install-java stub, not a usable JVM.
        substituteInPlace src/core/JavaInstallations.c \
          --replace-fail '#if defined(__linux__) || defined(__APPLE__)' \
          '#if defined(__linux__)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    qt6.qtbase
    curl
    json_c
    libarchive
    jdk8
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-Wno-error=format-security")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-error=format-security")
  ];

  dontWrapQtApps = true;

  runtimeDeps = [
    libGL
    glfw3-minecraft
    glib
    openal
    libglvnd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxxf86vm
    libxext
    libxcursor
    libxrandr
    libxtst
    libpulseaudio
    alsa-lib
    udev
  ];

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications"
      cp -r src/ui/Betacraft.app "$out/Applications/"
      # Upstream CMake copies this next to the binary at build time, but it is
      # not included when we install the .app bundle from the build tree.
      install -Dm555 ${finalAttrs.src}/lib/discord_game_sdk/aarch64/discord_game_sdk.dylib \
        "$out/Applications/Betacraft.app/Contents/MacOS/discord_game_sdk.dylib"
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm755 src/ui/Betacraft "$out/bin/betacraft-launcher-v2"
      install -Dm555 ${finalAttrs.src}/lib/discord_game_sdk/x86_64/discord_game_sdk.so \
        "$out/lib/betacraft-launcher-v2/discord_game_sdk.so"
      install -Dm444 ${finalAttrs.src}/assets/betacraft.png \
        $out/share/icons/hicolor/256x256/apps/betacraft-launcher-v2.png
      install -Dm444 ${finalAttrs.src}/assets/betacraft.desktop \
        $out/share/applications/betacraft-launcher-v2.desktop
      substituteInPlace $out/share/applications/betacraft-launcher-v2.desktop \
        --replace-fail "Exec=Betacraft" "Exec=betacraft-launcher-v2"
      substituteInPlace $out/share/applications/betacraft-launcher-v2.desktop \
        --replace-fail "Icon=betacraft" "Icon=betacraft-launcher-v2"
    ''}

    runHook postInstall
  '';

  postFixup = ''
    install -Dm755 ${javaSyncScript} $out/bin/betacraft-launcher-v2-sync-java

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      qtWrapperArgs+=(
        --prefix PATH : "${lib.makeBinPath (minecraftJdks ++ [ xrandr ])}"
        --set LD_LIBRARY_PATH ${lib.makeLibraryPath finalAttrs.runtimeDeps}:$out/lib/betacraft-launcher-v2
      )
      wrapQtAppsHook

      mv $out/bin/betacraft-launcher-v2 $out/bin/betacraft-launcher-v2-inner
      makeShellWrapper $out/bin/betacraft-launcher-v2-inner $out/bin/betacraft-launcher-v2 \
        --run "$out/bin/betacraft-launcher-v2-sync-java"
    ''}
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapQtAppsHook

      if [ -f "$out/Applications/Betacraft.app/Contents/MacOS/Betacraft" ]; then
        install_name_tool -add_rpath @executable_path \
          "$out/Applications/Betacraft.app/Contents/MacOS/Betacraft"
        mkdir -p "$out/bin"
        makeWrapper "$out/Applications/Betacraft.app/Contents/MacOS/Betacraft" \
          "$out/bin/betacraft-launcher-v2-inner" \
          --prefix PATH : "${lib.makeBinPath minecraftJdks}" \
          --prefix QT_PLUGIN_PATH : "${qt6.qtbase}/lib/qt-6/plugins"
        makeShellWrapper "$out/bin/betacraft-launcher-v2-inner" \
          "$out/bin/betacraft-launcher-v2" \
          --run "$out/bin/betacraft-launcher-v2-sync-java"
      fi
    ''}
  '';

  passthru.updateScript = nix-update-script {
    extraAttrs = [ "--version-regex=2\\.0\\.0-alpha\\.[0-9]+" ];
  };

  meta = {
    description = "Betacraft Launcher v2 (alpha) for legacy Minecraft versions up to 1.12.2";
    longDescription = ''
      Betacraft Launcher v2 is a C++/Qt rewrite of the Betacraft launcher.
      It is currently in alpha and supports Minecraft versions up to 1.12.2.

      This package registers nixpkgs JDK 8, 17, and 21 with the launcher on
      startup and avoids the macOS /usr/bin/java stub, so legacy instances can
      use native aarch64 Java without downloading Azul builds.
    '';
    homepage = "https://betacraft.uk";
    downloadPage = "https://betacraft.uk/downloads";
    changelog = "https://github.com/betacraftuk/betacraft-launcher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "betacraft-launcher-v2";
    maintainers = with lib.maintainers; [ aspauldingcode ];
    platforms = with lib.platforms; linux ++ [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
