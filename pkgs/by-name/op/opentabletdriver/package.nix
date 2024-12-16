{
  lib,
  buildDotnetModule,
  copyDesktopItems,
  coreutils,
  dotnetCorePackages,
  fetchFromGitHub,
  gtk3,
  jq,
  libappindicator,
  libevdev,
  libnotify,
  libX11,
  libXrandr,
  makeDesktopItem,
  nixosTests,
  udev,
  wrapGAppsHook3,
}:

buildDotnetModule rec {
  pname = "OpenTabletDriver";
  version = "0.6.4.0-unstable-2024-11-25";

  src = fetchFromGitHub {
    owner = "OpenTabletDriver";
    repo = "OpenTabletDriver";
    rev = "8b88b8bdc5144391f10eb61ee77803ba0ee83718"; # 0.6.x branch
    hash = "sha256-5JKkSqV9owkHgWXfjiyv5QRh86apDCPzpA6qha1i4D4=";
  };

  dotnetInstallFlags = [ "--framework=net8.0" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];
  nugetDeps = ./deps.nix;

  executables = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    # Dependency of generate-rules.sh
    jq
  ];

  runtimeDeps = [
    gtk3
    libappindicator
    libevdev
    libnotify
    libX11
    libXrandr
    udev
  ];

  buildInputs = runtimeDeps;

  doCheck = true;
  testProjectFile = "OpenTabletDriver.Tests/OpenTabletDriver.Tests.csproj";

  disabledTests = [
    # Require networking
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarballFork"
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarball"
    # Require networking & unused in Linux build
    "OpenTabletDriver.Tests.UpdaterTests.UpdaterBase_ProperlyChecks_Version_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_PreventsUpdate_WhenAlreadyUpToDate_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_AllowsReupdate_WhenInstallFailed_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_HasUpdateReturnsFalse_During_UpdateInstall_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_HasUpdateReturnsFalse_After_UpdateInstall_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_Prevents_ConcurrentAndConsecutive_Updates_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_ProperlyBackups_BinAndAppDataDirectory_Async"
    # Intended only to be run in continuous integration, unnecessary for functionality
    "OpenTabletDriver.Tests.ConfigurationTest.Configurations_DeviceIdentifier_IsNotConflicting"
    # Depends on processor load
    "OpenTabletDriver.Tests.TimerTests.TimerAccuracy"
    # Can't find Configurations directory
    "OpenTabletDriver.Tests.ConfigurationTest.Configurations_Verify_Configs_With_Schema"
  ];

  preBuild = ''
    patchShebangs generate-rules.sh
    substituteInPlace generate-rules.sh \
      --replace-fail '/usr/bin/env rm' '${lib.getExe' coreutils "rm"}'
  '';

  postFixup = ''
    # Give a more "*nix" name to the binaries
    mv $out/bin/OpenTabletDriver.Console $out/bin/otd
    mv $out/bin/OpenTabletDriver.Daemon $out/bin/otd-daemon
    mv $out/bin/OpenTabletDriver.UX.Gtk $out/bin/otd-gui

    install -Dm644 $src/OpenTabletDriver.UX/Assets/otd.png -t $out/share/pixmaps

    # Generate udev rules from source
    export OTD_CONFIGURATIONS="$src/OpenTabletDriver.Configurations/Configurations"
    mkdir -p $out/lib/udev/rules.d
    ./generate-rules.sh > $out/lib/udev/rules.d/70-opentabletdriver.rules
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "OpenTabletDriver";
      name = "OpenTabletDriver";
      exec = "otd-gui";
      icon = "otd";
      comment = "Open source, cross-platform, user-mode tablet driver";
      categories = [ "Utility" ];
    })
  ];

  passthru = {
    updateScript = ./update.sh;
    tests = {
      otd-runs = nixosTests.opentabletdriver;
    };
  };

  meta = {
    description = "Open source, cross-platform, user-mode tablet driver";
    homepage = "https://github.com/OpenTabletDriver/OpenTabletDriver";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      gepbird
      thiagokokada
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "otd";
  };
}
