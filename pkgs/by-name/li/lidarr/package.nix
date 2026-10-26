{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs-slim_24,
  nixosTests,
  nix-update-script,
}:
let
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule (finalAttrs: {
  pname = "lidarr";
  version = "3.1.0.4875";

  src = fetchFromGitHub {
    owner = "Lidarr";
    repo = "Lidarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RCJlToQw96U8seZaD/QCPL1Pn42yw5iXFWGJCHSHwQw=";
  };

  postPatch = ''
    mv src/NuGet.config NuGet.Config
  '';

  strictDeps = true;

  postInstall = ''
    cp -a -- ${finalAttrs.passthru.frontend} "$out"/lib/lidarr/UI
  '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # for tests

  __structuredAttrs = true; # for Copyright property that contains spaces

  executables = [ "Lidarr" ];

  projectFile = [
    "src/NzbDrone.Console/Lidarr.Console.csproj"
    "src/NzbDrone.Mono/Lidarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/NzbDrone.Api.Test/Lidarr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Lidarr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Lidarr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Lidarr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Lidarr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Lidarr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Lidarr.Test.Common.csproj"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
    "--property:SentryUploadSymbols=false" # Fix Sentry upload failed warnings
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright lidarr.audio (${finalAttrs.meta.license.fullName})"
    "--property:AssemblyVersion=${finalAttrs.versionForDotnet}"
    "--property:AssemblyConfiguration=master"
    "--property:RuntimeIdentifier=${rid}"
  ];

  # Skip manual, integration, automation and platform-dependent tests.
  testFilters = [
    "TestCategory!=ManualTest"
    "TestCategory!=IntegrationTest"
    "TestCategory!=AutomationTest"

    # makes real HTTP requests
    "FullyQualifiedName!~NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture"
    "FullyQualifiedName!~NzbDrone.Core.Test.ImportListTests.SpotifyMappingFixture"
    "FullyQualifiedName!~NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxyFixture"
    "FullyQualifiedName!~NzbDrone.Core.Test.MetadataSource.SkyHook.SkyHookProxySearchFixture"
  ]
  ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    # fails on macOS
    "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture"
  ];

  disabledTests = [
    # setgid tests
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
    "NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"

    # we do not set application data directory during tests (i.e. XDG data directory)
    "NzbDrone.Mono.Test.DiskProviderTests.FreeSpaceFixture.should_return_free_disk_space"
    "NzbDrone.Common.Test.ServiceFactoryFixture.event_handlers_should_be_unique"

    # attempts to read /etc/*release and fails since it does not exist
    "NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"

    # fails to start test dummy because it cannot locate .NET runtime for some reason
    "NzbDrone.Common.Test.ProcessProviderFixture.should_be_able_to_start_process"
    "NzbDrone.Common.Test.ProcessProviderFixture.exists_should_find_running_process"
    "NzbDrone.Common.Test.ProcessProviderFixture.kill_all_should_kill_all_process_with_name"
  ];

  passthru = {
    frontend = stdenvNoCC.mkDerivation {
      inherit (finalAttrs) src version;
      pname = "${finalAttrs.pname}-frontend";

      __structuredAttrs = true;
      strictDeps = true;

      nativeBuildInputs = [
        nodejs-slim_24
        yarnConfigHook
        yarnBuildHook
      ];

      yarnOfflineCache = fetchYarnDeps {
        yarnLock = "${finalAttrs.src}/yarn.lock";
        hash = "sha256-Jq2O7gvB+PKcz6uDBMg7ox6/Bu+pikXH6JGuLfKG5fI=";
      };

      yarnBuildFlags = [ "--env=production" ];

      installPhase = ''
        runHook preInstall
        mv _output/UI "$out"
        runHook postInstall
      '';
    };

    tests = { inherit (nixosTests) lidarr; };

    updateScript = nix-update-script {
      extraArgs = lib.cli.toCommandLineGNU { } {
        subpackage = "frontend";
        use-github-releases = true;
      };
    };
  };

  meta = {
    description = "Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio";
    changelog = "https://github.com/Lidarr/Lidarr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ramonacat
      karaolidis
      connor-grady
    ];
    mainProgram = "Lidarr";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
      fromSource
    ];
    # platforms inherited from dotnet-sdk.
  };
})
