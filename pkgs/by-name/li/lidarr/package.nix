{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
  chromaprint,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs-slim_24,
  nixosTests,
  nix-update-script,
  writeText,
}:
let
  inherit (stdenvNoCC.hostPlatform.extensions) sharedLibrary;
  fpcalc = lib.getExe chromaprint;
  libsqlite3 = "${lib.getLib sqlite}/lib/libsqlite3${sharedLibrary}";
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule (finalAttrs: {
  pname = "lidarr";
  version = "3.1.6.5079";

  src = fetchFromGitHub {
    owner = "Lidarr";
    repo = "Lidarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vazxW5aYlUjXo2SNSyspc+hk1HoLHI0brbm7e/qSrk0=";
  };

  postPatch = ''
    mv src/NuGet.config NuGet.Config
    rm -r src/Runtimes
  '';

  strictDeps = true;

  installPath = "${placeholder "out"}/lib/lidarr/bin";

  postInstall = ''
    cp -a -- ${finalAttrs.passthru.frontend} "$dotnetInstallPath"/UI
    cp -- ${finalAttrs.passthru.package_info} "$dotnetInstallPath"/../package_info
    ln -sf -- ${libsqlite3} "$dotnetInstallPath"/libe_sqlite3${sharedLibrary}
    ln -s -- ${fpcalc} "$dotnetInstallPath"/fpcalc
  '';

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  preCheck = ''
    ln -sf -- ${libsqlite3} _tests/net8.0/${rid}/libe_sqlite3${sharedLibrary}
    ln -s -- ${fpcalc} _tests/net8.0/${rid}/fpcalc
  '';

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
    "src/NzbDrone.Update.Test/Lidarr.Update.Test.csproj"
  ];

  # https://github.com/NixOS/nixpkgs/pull/491217
  dotnetTestFlags = lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    "--environment:DOTNET_SYSTEM_NET_DISABLEIPV6=1"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
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

    "FullyQualifiedName!~NzbDrone.Core.Test.ParserTests.FingerprintingServiceFixture.should_fingerprint_file"
    "FullyQualifiedName!~NzbDrone.Core.Test.ParserTests.FingerprintingServiceFixture.should_lookup_file"
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

    "NzbDrone.Core.Test.ParserTests.FingerprintingServiceFixture.should_lookup_list"
    "NzbDrone.Core.Test.ParserTests.FingerprintingServiceFixture.should_lookup_list_when_fpcalc_fails_for_some_files"
    "NzbDrone.Core.Test.ParserTests.FingerprintingServiceFixture.should_not_fail_for_some_invalid_fingerprints"
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

    package_info = writeText "${finalAttrs.pname}-package_info" (
      lib.generators.toKeyValue { } {
        PackageAuthor = "[NixOS](https://nixos.org)";
        PackageVersion = finalAttrs.version;
        UpdateMethod = "External";
        UpdateMethodMessage = "Lidarr is managed by Nix. Update it through your system configuration.";
      }
    );

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
