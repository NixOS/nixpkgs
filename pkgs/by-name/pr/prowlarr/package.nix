{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
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
  version = "1.37.0.5076";
  # The dotnet8 compatibility patches also change `yarn.lock`, so we must pass
  # the already patched lockfile to `fetchYarnDeps`.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Prowlarr";
      repo = "Prowlarr";
      tag = "v${version}";
      hash = "sha256-uSdZaPq/aXehmRKMobwYNs5iYGPv5R76Ix9lCEVdLzM=";
    };
    postPatch = ''
      mv src/NuGet.config NuGet.Config
    '';
    patches = lib.optionals (lib.versionOlder version "2.0") [
      # See https://github.com/Prowlarr/Prowlarr/pull/2399
      # Unfortunately, the .NET 8 upgrade will be merged into the v2 branch,
      # and it may take some time for that to become stable.
      # However, the patches cleanly apply to v1 as well.
      (fetchpatch {
        name = "dotnet8-compatibility";
        url = "https://github.com/Prowlarr/Prowlarr/commit/21c408a7dac8abaac91c05958f18a556220b2304.patch";
        hash = "sha256-Es7JEXycOJPMXN+Kgv4wRnJA+l6zltUdP2i/wVodTBs=";
      })
      (fetchpatch {
        name = "dotnet8-darwin-compatibility";
        url = "https://github.com/Prowlarr/Prowlarr/commit/7a1fca5e23a3e75a9a2b2e1073a33eaa2ce865fe.patch";
        hash = "sha256-bReCHXC3RHgm1MYmE2kGqStt4fuBHowcupLIXT3fEes=";
      })
      (fetchpatch {
        name = "bump-swashbuckle-version";
        url = "https://github.com/Prowlarr/Prowlarr/commit/8eec321a0eaa396e2f964576e5883890c719b202.patch";
        hash = "sha256-SOdzGvq8FFYa451zTOw8yD1CDvM++AiFYFHhFW5Soco=";
      })
    ];
  };
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule {
  pname = "prowlarr";
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
    hash = "sha256-QVyjo/Zshy+61qocGKa3tZS8gnHvvVqenf79FkiXDBM=";
  };

  postConfigure = ''
    yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs --build node_modules
  '';
  postBuild = ''
    yarn --offline run build --env production
  '';
  postInstall = ''
    cp -a -- _output/UI "$out/lib/prowlarr/UI"
  '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # for tests

  __structuredAttrs = true; # for Copyright property that contains spaces

  executables = [ "Prowlarr" ];

  projectFile = [
    "src/NzbDrone.Console/Prowlarr.Console.csproj"
    "src/NzbDrone.Mono/Prowlarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/Prowlarr.Api.V1.Test/Prowlarr.Api.V1.Test.csproj"
    "src/NzbDrone.Common.Test/Prowlarr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Prowlarr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Prowlarr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Prowlarr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Prowlarr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Prowlarr.Test.Common.csproj"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
    "--property:SentryUploadSymbols=false" # Fix Sentry upload failed warnings
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2025 prowlarr.com (GNU General Public v3)"
    "--property:AssemblyVersion=${version}"
    "--property:AssemblyConfiguration=master"
    "--property:RuntimeIdentifier=${rid}"
  ];

  # Skip manual, integration, automation and platform-dependent tests.
  testFilters =
    [
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
  ];

  passthru = {
    tests = {
      inherit (nixosTests) prowlarr;
    };

    updateScript = writers.writePython3 "prowlarr-updater" {
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
    description = "Indexer manager/proxy built on the popular arr .net/reactjs base stack";
    homepage = "https://prowlarr.com/";
    changelog = "https://github.com/Prowlarr/Prowlarr/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      pizzapim
      nyanloutre
    ];
    mainProgram = "Prowlarr";
    # platforms inherited from dotnet-sdk.
  };
}
