{
  lib,
  stdenv,
  qt6,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  boost,
  protobuf,
  openssl,
  libiconv,
  abseil-cpp,
  target ? "client",
}:

let
  isClient = target == "client";
  isServer = target == "server";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pokerth-${target}";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "pokerth";
    repo = "pokerth";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IO/exgnKYGx+cut0gGZ83uUvUFPWyHH+lP6hlRuhSY8=";
  };

  postPatch =
    lib.optionalString isClient ''
      # Keep the current QML client and its resources in the client install component.
      substituteInPlace src/gui/qt6-qml/CMakeLists.txt \
        --replace-fail \
          'install(TARGETS pokerth_qml-client DESTINATION bin OPTIONAL)' \
          'install(TARGETS pokerth_qml-client DESTINATION bin OPTIONAL COMPONENT pokerth_client)' \
        --replace-fail \
          'install(DIRECTORY ../../../data DESTINATION share/pokerth)' \
          'install(DIRECTORY ../../../data DESTINATION share/pokerth COMPONENT pokerth_client)' \
        --replace-fail \
          'install(FILES ../../../pokerth_qml.desktop DESTINATION share/applications)' \
          'install(FILES ../../../pokerth_qml.desktop DESTINATION share/applications COMPONENT pokerth_client)' \
        --replace-fail \
          'install(FILES ../../../pokerth.png DESTINATION share/pixmaps)' \
          'install(FILES ../../../pokerth.png DESTINATION share/pixmaps COMPONENT pokerth_client)'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # nixpkgs protobuf propagates abseil properly; skip explicit
      # find_package which would also require unavailable utf8_range
      substituteInPlace CMakeLists.txt \
        --replace-fail 'elseif(APPLE)' 'elseif(FALSE)'

      # Boost lexical_cast + enums fails under Apple Clang due to strict
      # constexpr rules. Cast GameState to int before lexical_cast.
      substituteInPlace src/engine/log.cpp \
        --replace-fail \
          'boost::lexical_cast<string>(currentRound)' \
          'boost::lexical_cast<string>(static_cast<int>(currentRound))'
      substituteInPlace src/gui/qt/gametable/log/guilog.cpp \
        --replace-fail \
          'boost::lexical_cast<std::string>(GAME_STATE_PREFLOP)' \
          'boost::lexical_cast<std::string>(static_cast<int>(GAME_STATE_PREFLOP))'
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && isServer) ''
      # Server compiles convhelper.cpp which uses iconv (not in glibc on macOS)
      substituteInPlace src/CMakeLists.txt \
        --replace-fail \
          'target_link_libraries(pokerth_dedicated_server PRIVATE Qt6::Xml Qt6::Sql)' \
          'target_link_libraries(pokerth_dedicated_server PRIVATE "-liconv" Qt6::Xml Qt6::Sql)'
    '';

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && isClient) [
    makeWrapper
  ];

  # On macOS, QT_PLUGIN_PATH is not read by Qt6! only
  # QT_QPA_PLATFORM_PLUGIN_PATH works for platform plugin discovery.
  # Adding qtbase/bin to PATH also enables the PATH-based plugin path
  # derivation from the nixpkgs qtbase patch.
  qtWrapperArgs = lib.optionals stdenv.hostPlatform.isDarwin [
    "--prefix QT_QPA_PLATFORM_PLUGIN_PATH : ${qt6.qtbase}/lib/qt-6/plugins/platforms"
    "--prefix PATH : ${qt6.qtbase}/bin"
  ];

  buildInputs = [
    boost
    openssl
    protobuf
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwebsockets
    qt6.qttools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    abseil-cpp
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && isServer) [
    libiconv # server compiles convhelper.cpp which needs iconv
  ];

  buildFlags = [ (if isClient then "pokerth_qml-client" else "pokerth_dedicated_server") ];

  installPhase = ''
    runHook preInstall
    cmake --install . --component ${if isClient then "pokerth_client" else "pokerth_dedicated_server"}
    ${lib.optionalString isClient ''
      substituteInPlace "$out/share/applications/pokerth_qml.desktop" \
        --replace-fail \
          'Exec=env QT_SCALE_FACTOR=1 QT_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt6/plugins QML_IMPORT_PATH=/usr/lib/x86_64-linux-gnu/qt6/qml pokerth_qml-client' \
          'Exec=env QT_SCALE_FACTOR=1 pokerth_client' \
        --replace-fail \
          'StartupWMClass=pokerth_qml-client' \
          'StartupWMClass=pokerth_client'
      # The legacy Widgets desktop entry is also installed by upstream; publish
      # only the current QML entry and use the conventional application name.
      rm "$out/share/applications/pokerth.desktop"
      mv "$out/share/applications/pokerth_qml.desktop" "$out/share/applications/pokerth.desktop"
      mv "$out/bin/pokerth_qml-client" "$out/bin/pokerth_client"
    ''}
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.hostPlatform.isDarwin && isClient) ''
    appName="PokerTH"
    appBundle="$out/Applications/$appName.app"
    appContents="$appBundle/Contents"
    appMacOS="$appContents/MacOS"
    appResources="$appContents/Resources"

    mkdir -p "$appMacOS" "$appResources"

    # Extract the current Info.plist template from upstream's shared bundle helper.
    awk '/cat > .*Info.plist.*<<EOF/ { found=1; next } /^EOF$/ && found { exit } found { print }' \
      "$src/build_macos_common.sh" > "$appContents/Info.plist"

    substituteInPlace "$appContents/Info.plist" \
      --replace-fail '$APP_NAME' "$appName" \
      --replace-fail '$BUNDLE_ID' 'net.pokerth.PokerTH' \
      --replace-fail '$VERSION' '${finalAttrs.version}'

    # Move the cmake-installed binary into the app bundle
    mv "$out/bin/pokerth_client" "$appMacOS/$appName"

    # pokerth.icns is tracked in git at repo root
    cp "$src/pokerth.icns" "$appResources/"

    # Data directory (gfx, sounds, fonts, stylesheets, translations) — already
    # installed to $out/share/pokerth/data by cmake.  Symlink into the bundle so
    # the macOS code path (../Resources/data/) in qthelper.cpp finds it.
    ln -s "$out/share/pokerth/data" "$appResources/data"

    # CLI entry points both pointing to the app bundle binary
    makeWrapper "$appMacOS/$appName" "$out/bin/pokerth_client"
    makeWrapper "$appMacOS/$appName" "$out/bin/pokerth"
  '';

  postFixup = lib.optionalString (stdenv.hostPlatform.isDarwin && isClient) ''
    # Finder launches the bundle executable directly, outside the wrappers
    # created for the CLI entry points in $out/bin.
    wrapQtApp "$out/Applications/PokerTH.app/Contents/MacOS/PokerTH"
  '';

  meta = {
    homepage = "https://www.pokerth.net";
    description = if isClient then "Poker game client" else "Poker game dedicated server";
    mainProgram = if isClient then "pokerth_client" else "pokerth_dedicated_server";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      obadz
      philocalyst
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    changelog = "https://github.com/pokerth/pokerth/blob/v${finalAttrs.version}/ChangeLog";
  };
})
