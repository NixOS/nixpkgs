{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
  withFFmpeg ? true, # replace bundled ffprobe binary with symlink to ffmpeg package.
  servarr-ffmpeg,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  nixosTests,
  # update script
  writers,
  python3Packages,
  nix,
  prefetch-yarn-deps,
  fetchpatch,
  applyPatches,
}:
let
  version = "6.0.4.10291";
  # The dotnet8 compatibility patches also change `yarn.lock`, so we must pass
  # the already patched lockfile to `fetchYarnDeps`.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Radarr";
      repo = "Radarr";
      tag = "v${version}";
      hash = "sha256-SDkLVKHTqAnZQ4AYIW9fHvnga8EV/NVfzia/Ce0G+Uc=";
    };
    postPatch = ''
      mv src/NuGet.config NuGet.Config
    '';
    patches = lib.optionals (lib.versionOlder version "6.0") [
      # See https://github.com/Radarr/Radarr/pull/11064
      # Unfortunately, the .NET 8 upgrade will be merged into the v6 branch,
      # and it may take some time for that to become stable.
      # However, the patches cleanly apply to v5 as well.
      (fetchpatch {
        name = "dotnet8-compatibility";
        url = "https://github.com/Radarr/Radarr/commit/2235823af313ea1f39fd1189b69a75fc5d380c41.patch";
        hash = "sha256-3YgQV4xc2i5DNWp2KxVz6M5S8n//a/Js7pckGZ06fWc=";
      })
      (fetchpatch {
        name = "dotnet8-darwin-compatibility";
        url = "https://github.com/Radarr/Radarr/commit/2a886fb26a70b4d48a4ad08d7ee23e5e4d81f522.patch";
        hash = "sha256-SAMUHqlSj8FPq20wY8NWbRytVZXTPtMXMfM3CoM8kSA=";
      })
    ];
  };
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule {
  pname = "radarr";
  inherit version src;

  strictDeps = true;
  nativeBuildInputs = [
    nodejs
    yarn
    prefetch-yarn-deps
    fixup-yarn-lock
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-Ng7ZsUfGBKtNktJeuI4Q6+tMN2ZPj+pVSQ+0Ssy5gRc=";
  };

  ffprobe = lib.optionalDrvAttr withFFmpeg (lib.getExe' servarr-ffmpeg "ffprobe");

  postConfigure = ''
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs --build node_modules
  '';
  postBuild = ''
    yarn --offline run build --env production
  '';
  postInstall =
    lib.optionalString withFFmpeg ''
      rm -- "$out/lib/radarr/ffprobe"
      ln -s -- "$ffprobe" "$out/lib/radarr/ffprobe"
    ''
    + ''
      cp -a -- _output/UI "$out/lib/radarr/UI"
    '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # for tests

  __structuredAttrs = true; # for Copyright property that contains spaces

  executables = [ "Radarr" ];

  projectFile = [
    "src/NzbDrone.Console/Radarr.Console.csproj"
    "src/NzbDrone.Mono/Radarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/NzbDrone.Api.Test/Radarr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Radarr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Radarr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Radarr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Radarr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Radarr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Radarr.Test.Common.csproj"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
    "--property:SentryUploadSymbols=false" # Fix Sentry upload failed warnings
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2025 radarr.video (GNU General Public v3)"
    "--property:AssemblyVersion=${version}"
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
  ]
  ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
    # flaky on darwin
    "NzbDrone.Core.Test.NotificationTests.TraktServiceFixture.should_add_collection_movie_if_valid_mediainfo"
    "NzbDrone.Core.Test.NotificationTests.TraktServiceFixture.should_format_audio_channels_to_one_decimal_when_adding_collection_movie"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) radarr;
    };

    updateScript = writers.writePython3 "radarr-updater" {
      libraries = with python3Packages; [ requests ];
      flakeIgnore = [ "E501" ];
      makeWrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath [
          nix
          prefetch-yarn-deps
        ])
      ];
    } ./update.py;
  };

  meta = {
    description = "Usenet/BitTorrent movie downloader";
    homepage = "https://radarr.video";
    changelog = "https://github.com/Radarr/Radarr/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      edwtjo
      purcell
      nyanloutre
    ];
    mainProgram = "Radarr";
    # platforms inherited from dotnet-sdk.
  };
}
