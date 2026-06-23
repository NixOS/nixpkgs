{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  dbus,
  libx11,
  libusb1,
  pkg-config,
  udev,
  wayland,
  wayland-scanner,
  libxkbcommon,
  gtk3,
  libayatana-appindicator,
  asio_1_32_0,
  apple-sdk_15,
  karabiner-dk,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keymapper";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "houmain";
    repo = "keymapper";
    tag = finalAttrs.version;
    hash = "sha256-0GadjBGgawn0V+PV04R6ULmanNUF7R14N/jHhObcTzM=";
  };

  # Darwin sandbox prevents downloads during build (FetchContent).
  # Replace upstream's FetchContent_Declare for asio with a vendored copy
  # and wrap the dead code in if(FALSE).
  # The launchd script references hardcoded system paths for the Karabiner
  # driver daemon; point them at the nix store instead.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '  include(FetchContent)' '  include_directories(${asio_1_32_0}/include)' \
      --replace-fail '  FetchContent_Declare(asio' $'  if(FALSE)\n  FetchContent_Declare(asio' \
      --replace-fail '  include_directories(''${asio_SOURCE_DIR}/asio/include)' '  endif()'

    substituteInPlace extra/keymapper-launchd \
      --replace-fail \
        'karabiner_path="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"' \
        'karabiner_path="${karabiner-dk}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"' \
      --replace-fail \
        'karabiner_manager_path="/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"' \
        'karabiner_manager_path="${karabiner-dk}/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"'
  '';

  # all the following must be in nativeBuildInputs
  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    wayland
    wayland-scanner
    libx11
    udev
    libusb1
    libxkbcommon
    gtk3
    libayatana-appindicator
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  cmakeFlags = [
    (lib.cmakeFeature "VERSION" finalAttrs.version)
  ];

  postInstall = ''
    chmod +x $out/bin/keymapper-launchd
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    status=0
    $out/bin/keymapper --help > keymapper-help.txt || status=$?
    test "$status" -eq 1
    grep -F 'Usage: keymapper [-options]' keymapper-help.txt > /dev/null

    status=0
    $out/bin/keymapperd --help > keymapperd-help.txt || status=$?
    test "$status" -eq 1
    grep -F 'Usage: keymapperd [-options]' keymapperd-help.txt > /dev/null

    status=0
    $out/bin/keymapperctl --help > keymapperctl-help.txt || status=$?
    test "$status" -eq 2
    grep -F 'Usage: keymapperctl [--operation]' keymapperctl-help.txt > /dev/null

    runHook postInstallCheck
  '';

  meta = {
    changelog = "https://github.com/houmain/keymapper/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Cross-platform context-aware key remapper";
    homepage = "https://github.com/houmain/keymapper";
    license = lib.licenses.gpl3Only;
    mainProgram = "keymapper";
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };

  passthru = {
    updateScript = nix-update-script { };

    darwinDriverVersion = "6.2.0"; # needs to be updated if karabiner-driverkit changes
    darwinDriver =
      if stdenv.hostPlatform.isDarwin then
        (karabiner-dk.override {
          driver-version = finalAttrs.passthru.darwinDriverVersion;
        })
      else
        null;

  };
})
