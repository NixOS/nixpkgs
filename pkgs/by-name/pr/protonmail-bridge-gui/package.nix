{ lib
, stdenv
, pkg-config
, libsecret
, cmake
, ninja
, qt6
, grpc
, protobuf
, zlib
, gtest
, sentry-native
, protonmail-bridge
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protonmail-bridge-gui";

  inherit (protonmail-bridge) version src;

  patches = [
    # Use `gtest` from Nixpkgs to allow an offline build
    ./use-nix-googletest.patch
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtwayland
    qt6.qtsvg
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libsecret
    grpc
    protobuf
    zlib
    gtest
    sentry-native
  ];

  sourceRoot = "${finalAttrs.src.name}/internal/frontend/bridge-gui";

  postPatch = ''
    # Bypass `vcpkg` by deleting lines that `include` BridgeSetup.cmake
    find . -type f -name "CMakeLists.txt" -exec sed -i "/BridgeSetup\\.cmake/d" {} \;

    # Use the available ICU version
    sed -i "s/libicu\(i18n\|uc\|data\)\.so\.56/libicu\1.so/g" bridge-gui/DeployLinux.cmake

    # Create a Desktop Entry that uses a `protonmail-bridge-gui` binary without upstream's launcher
    sed "s/^\(Icon\|Exec\)=.*$/\1=protonmail-bridge-gui/" ../../../dist/proton-bridge.desktop > proton-bridge-gui.desktop

    # Also update `StartupWMClass` to match the GUI binary's `wmclass` (Wayland app id)
    sed -i "s/^\(StartupWMClass=\)Proton Mail Bridge$/\1ch.proton.bridge-gui/" proton-bridge-gui.desktop

    # Don't build `bridge-gui-tester`
    sed -i "/add_subdirectory(bridge-gui-tester)/d" CMakeLists.txt
  '';

  cmakeFlags = [
    "-DBRIDGE_APP_FULL_NAME=Proton Mail Bridge"
    "-DBRIDGE_VENDOR=Proton AG"
    "-DBRIDGE_REVISION=${finalAttrs.src.rev}"
    "-DBRIDGE_TAG=${finalAttrs.version}"
    "-DBRIDGE_BUILD_ENV=Nix"
    "-DBRIDGE_APP_VERSION=${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall

    # Install the GUI binary
    install -Dm755 bridge-gui/bridge-gui $out/lib/bridge-gui

    # Symlink the backend binary from the protonmail-bridge (CLI) package
    ln -s ${protonmail-bridge}/bin/protonmail-bridge $out/lib/bridge

    # Symlink the GUI binary
    mkdir -p $out/bin
    ln -s $out/lib/bridge-gui $out/bin/protonmail-bridge-gui

    # Install desktop assets
    install -Dm644 ../proton-bridge-gui.desktop -t $out/share/applications
    install -Dm644 ../../../../dist/bridge.svg $out/share/icons/hicolor/scalable/apps/protonmail-bridge-gui.svg

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/ProtonMail/proton-bridge/blob/${finalAttrs.src.rev}/Changelog.md";
    description = "Qt-based GUI to use your ProtonMail account with your local e-mail client";
    downloadPage = "https://github.com/ProtonMail/proton-bridge/releases";
    homepage = "https://github.com/ProtonMail/proton-bridge";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Provides a GUI application that runs in the background and seamlessly encrypts
      and decrypts your mail as it enters and leaves your computer.

      To work, use secret-service freedesktop.org API (e.g. Gnome keyring) or pass.
    '';
    mainProgram = "protonmail-bridge-gui";
    maintainers = with lib.maintainers; [ daniel-fahey ];
    platforms = lib.platforms.linux;
  };
})
