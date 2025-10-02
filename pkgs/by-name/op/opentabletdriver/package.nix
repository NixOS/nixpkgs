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
  versionCheckHook,
  nix-update-script,
  udevCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "OpenTabletDriver";
  version = "0.6.6.0";

  src = fetchFromGitHub {
    owner = "OpenTabletDriver";
    repo = "OpenTabletDriver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NS/r4FU3dT7UT+R7NryRnU5RfLEN0E6pSqtNDpKMS7U=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  projectFile = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];
  nugetDeps = ./deps.json;

  executables = [
    "OpenTabletDriver.Console"
    "OpenTabletDriver.Daemon"
    "OpenTabletDriver.UX.Gtk"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    udevCheckHook
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

  buildInputs = finalAttrs.runtimeDeps;

  OTD_CONFIGURATIONS = "${finalAttrs.src}/OpenTabletDriver.Configurations/Configurations";

  doCheck = true;
  testProjectFile = "OpenTabletDriver.Tests/OpenTabletDriver.Tests.csproj";

  disabledTests = [
    # Require networking & unused in Linux build
    "OpenTabletDriver.Tests.UpdaterTests.CheckForUpdates_Returns_Update_When_Available"
    "OpenTabletDriver.Tests.UpdaterTests.Install_Throws_UpdateAlreadyInstalledException_When_AlreadyInstalled"
    "OpenTabletDriver.Tests.UpdaterTests.Install_DoesNotThrow_UpdateAlreadyInstalledException_When_PreviousInstallFailed"
    "OpenTabletDriver.Tests.UpdaterTests.Install_Throws_UpdateInProgressException_When_AnotherUpdate_Is_InProgress"
    "OpenTabletDriver.Tests.UpdaterTests.Install_Moves_UpdatedBinaries_To_BinDirectory"
    "OpenTabletDriver.Tests.UpdaterTests.Install_Moves_Only_ToBeUpdated_Binaries"
    "OpenTabletDriver.Tests.UpdaterTests.Install_Copies_AppDataFiles"
    # Depends on processor load
    "OpenTabletDriver.Tests.TimerTests.TimerAccuracy"
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

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/otd-daemon";

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      otd-runs = nixosTests.opentabletdriver;
    };
  };

  meta = {
    changelog = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/tag/v${finalAttrs.version}";
    description = "Open source, cross-platform, user-mode tablet driver";
    homepage = "https://github.com/OpenTabletDriver/OpenTabletDriver";
    license = lib.licenses.lgpl3Plus;
    mainProgram = "otd";
    maintainers = with lib.maintainers; [
      gepbird
      thiagokokada
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
