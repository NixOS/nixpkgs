{
  lib,
  _7zz,
  buildDotnetModule,
  copyDesktopItems,
  desktop-file-utils,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  glibc,
  libICE,
  libSM,
  libX11,
  nexusmods-app,
  runCommand,
  xdg-utils,
  enableUnfree ? false, # Set to true to support RAR format mods
}:
let
  _7zzWithOptionalUnfreeRarSupport = _7zz.override { inherit enableUnfree; };

  # From https://nexus-mods.github.io/NexusMods.App/developers/Contributing/#for-package-maintainers
  # TODO: add DefineConstants support to buildDotnetModule
  constants = [
    # Tell the app it is a distro package; affects wording in update prompts
    "INSTALLATION_METHOD_PACKAGE_MANAGER"

    # Don't include upstream's 7zz binary; we use the nixpkgs version
    "NEXUSMODS_APP_USE_SYSTEM_EXTRACTOR"
  ];
in
buildDotnetModule rec {
  pname = "nexusmods-app" + lib.strings.optionalString enableUnfree "-unfree";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "NexusMods.App";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-vy7gc/pS29gphkWM/KezZxXDVsD5DV02b/72pPh2Y2c=";
  };

  # If the whole solution is published, there seems to be a race condition where
  # it will sometimes publish the wrong version of a dependent assembly, for
  # example: Microsoft.Extensions.Hosting.dll 6.0.0 instead of 8.0.0.
  # https://learn.microsoft.com/en-us/dotnet/core/compatibility/sdk/7.0/solution-level-output-no-longer-valid
  # TODO: do something about this in buildDotnetModule
  projectFile = "src/NexusMods.App/NexusMods.App.csproj";
  testProjectFile = "NexusMods.App.sln";

  nativeBuildInputs = [ copyDesktopItems ];

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetBuildFlags = [
    # From https://github.com/Nexus-Mods/NexusMods.App/blob/v0.5.3/src/NexusMods.App/app.pupnet.conf#L38
    "--property:Version=${version}"
    "--property:TieredCompilation=true"
    "--property:DefineConstants=${lib.strings.concatStringsSep "%3B" constants}"
  ];

  postPatch = ''
    # We still need to do this because the tests don't seem to respect NEXUSMODS_APP_USE_SYSTEM_EXTRACTOR
    # TODO: check we are setting NEXUSMODS_APP_USE_SYSTEM_EXTRACTOR correctly, then discuss the issue upstream.
    ln --force --symbolic "${lib.getExe _7zzWithOptionalUnfreeRarSupport}" src/ArchiveManagement/NexusMods.FileExtractor/runtimes/linux-x64/native/7zz

    # for some reason these tests fail (intermittently?) with a zero timestamp
    touch tests/NexusMods.UI.Tests/WorkspaceSystem/*.verified.png

    # TODO: Should we patch the desktop file here?
  '';

  makeWrapperArgs = [
    # Ensure 7zz is on the PATH
    # TODO: is there a better way to do this?
    "--prefix PATH : ${
      lib.makeBinPath [
        _7zzWithOptionalUnfreeRarSupport
        xdg-utils
        desktop-file-utils
      ]
    }"

    # Make associating with nxm links work on Linux
    # TODO: is this still needed when we use INSTALLATION_METHOD_PACKAGE_MANAGER?
    "--set APPIMAGE ${placeholder "out"}/bin/NexusMods.App"
  ];

  # TODO: is this needed?
  buildInputs = [ _7zzWithOptionalUnfreeRarSupport ];

  runtimeDeps = [
    # TODO: Is this needed here? This only adds to LD_LIBRARY_PATH, not PATH...
    _7zzWithOptionalUnfreeRarSupport
    # TODO: is this still needed when we use INSTALLATION_METHOD_PACKAGE_MANAGER?
    desktop-file-utils
    fontconfig
    libICE
    libSM
    libX11
    glibc
  ];

  executables = [ "NexusMods.App" ];

  doCheck = true;

  dotnetTestFlags =
    let
      # NOTE: Can't use `disabledTests` because we have additional category based filters
      filters =
        [
          "Category!=Disabled"
          "FlakeyTest!=True"
          "RequiresNetworking!=True"
        ]
        ++ lib.map (n: "FullyQualifiedName!=${n}") (
          [
            "NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_RemoteImage"
            "NexusMods.UI.Tests.ImageCacheTests.Test_LoadAndCache_ImageStoredFile"
          ]
          ++ lib.optionals (!enableUnfree) [
            "NexusMods.Games.FOMOD.Tests.FomodXmlInstallerTests.InstallsFilesSimple_UsingRar"
          ]
        );
    in
    [
      "--environment=USER=nobody"
      "--filter=${lib.strings.concatStringsSep "&" filters}"
      "--property:DefineConstants=${lib.strings.concatStringsSep "%3B" constants}"
    ];

  passthru = {
    # FIXME: won't this use the _wrong_ derivation when called with non-default `callPackage` arguments?
    # Maybe we can use a fixed-point argument when calling `buildDotnetModule`?
    tests = {
      serve = runCommand "${pname}-test-serve" { } ''
        ${lib.getExe nexusmods-app}
        touch $out
      '';
      help = runCommand "${pname}-test-help" { } ''
        ${lib.getExe nexusmods-app}
        touch $out
      '';
      associate-nxm = runCommand "${pname}-test-associate-nxm" { } ''
        ${lib.getExe nexusmods-app}
        touch $out
      '';
      list-tools = runCommand "${pname}-test-list-tools" { } ''
        ${lib.getExe nexusmods-app}
        touch $out
      '';
    };
    updateScript = ./update.bash;
  };

  meta = {
    description = "Game mod installer, creator and manager";
    mainProgram = "NexusMods.App";
    homepage = "https://github.com/Nexus-Mods/NexusMods.App";
    changelog = "https://github.com/Nexus-Mods/NexusMods.App/releases/tag/${src.rev}";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = with lib.maintainers; [
      l0b0
      MattSturgeon
    ];
    platforms = lib.platforms.linux;
  };
}
