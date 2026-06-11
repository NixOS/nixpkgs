{
  lib,
  stdenv,
  pkg-config,
  libsecret,
  cmake,
  ninja,
  qt6,
  grpc,
  protobuf,
  zlib,
  gtest,
  sentry-native,
  protonmail-bridge,
  fetchpatch2,
}:

let
  guiSourcePath = "internal/frontend/bridge-gui";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "protonmail-bridge-gui";

  inherit (protonmail-bridge) version src;

  patches = [
    # Use `gtest` from Nixpkgs to allow an offline build
    ./use-nix-googletest.patch
    # fix: qt6_generate_deploy_app_script deprecated keyword
    (fetchpatch2 {
      url = "https://github.com/daniel-fahey/proton-bridge/commit/9b282369523ce2aabcf95369a2ed3867efb5a4ac.patch?full_index=1";
      relative = guiSourcePath;
      hash = "sha256-CGBelsplAqLI+6GtDR+VELfVsLoHPN0324gfZ3obKpI=";
    })
    # fix: make libQt6WaylandEglClientHwIntegration conditional for Qt 6.10
    (fetchpatch2 {
      url = "https://github.com/daniel-fahey/proton-bridge/commit/7823fe4904186253798fc633724988d43dd642e0.patch?full_index=1";
      relative = guiSourcePath;
      hash = "sha256-2heMfZdXLL8/uyM0jZ860Jw76c+gHtc0G6pWmIRCONY=";
    })
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

  sourceRoot = "${finalAttrs.src.name}/${guiSourcePath}";

  postPatch = ''
    # Bypass `vcpkg` by deleting lines that `include` BridgeSetup.cmake
    find . -type f -name "CMakeLists.txt" -exec sed -i "/BridgeSetup\\.cmake/d" {} \;

    # Use the available ICU version
    sed -i "s/libicu\(i18n\|uc\|data\)\.so\.[0-9][0-9]/libicu\1.so/g" bridge-gui/DeployLinux.cmake

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
