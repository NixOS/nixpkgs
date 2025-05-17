{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  sqlite,
  withFFmpeg ? true, # replace bundled ffprobe binary with symlink to ffmpeg package.
  ffmpeg,
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
  version = "5.22.4.9896";
  # The dotnet8 compatibility patches also change `yarn.lock`, so we must pass
  # the already patched lockfile to `fetchYarnDeps`.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Radarr";
      repo = "Radarr";
      tag = "v${version}";
      hash = "sha256-0JueDbkGokQLXzdNozepUoqBUCtHPdeObXh7wwstuXw=";
    };
    patches =
      [
        ./nuget-config.patch
      ]
      ++ lib.optionals (lib.versionOlder version "6.0") [
        # See https://github.com/Radarr/Radarr/pull/11064
        # Unfortunately, the .NET 8 upgrade will be merged into the v6 branch,
        # and it may take some time for that to become stable.
        # However, the patches cleanly apply to v5 as well.
        (fetchpatch {
          name = "dotnet8-compatibility";
          url = "https://github.com/Radarr/Radarr/commit/2799a475eee8b5ee7b2465f4bc41fd343456c9d8.patch";
          hash = "sha256-voAKxDoKyWtkdwi5i4TlsQW8t2XzloRPF1PqcKOxgpw=";
        })
        (fetchpatch {
          name = "dotnet8-darwin-compatibility";
          url = "https://github.com/Radarr/Radarr/commit/539f318884106c6faccfe1701fe06865d293cf95.patch";
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
    hash = "sha256-lxOmheBRqVI39I6fOoXWpGhb1fseHC8Mo/KhbRRYHI8=";
  };

  ffprobe = lib.optionalDrvAttr withFFmpeg (lib.getExe' ffmpeg "ffprobe");

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
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2025 radarr.video (GNU General Public v3)"
    "--property:AssemblyVersion=${version}"
    "--property:AssemblyConfiguration=main"
    "--property:RuntimeIdentifier=${rid}"
  ];

  # Skip manual, integration, automation and platform-dependent tests.
  dotnetTestFlags = [
    "--filter:${
      lib.concatStringsSep "&" (
        [
          "TestCategory!=ManualTest"
          "TestCategory!=IntegrationTest"
          "TestCategory!=AutomationTest"

          # setgid tests
          "FullyQualifiedName!=NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_preserve_setgid_on_set_folder_permissions"
          "FullyQualifiedName!=NzbDrone.Mono.Test.DiskProviderTests.DiskProviderFixture.should_clear_setgid_on_set_folder_permissions"

          # we do not set application data directory during tests (i.e. XDG data directory)
          "FullyQualifiedName!=NzbDrone.Mono.Test.DiskProviderTests.FreeSpaceFixture.should_return_free_disk_space"

          # attempts to read /etc/*release and fails since it does not exist
          "FullyQualifiedName!=NzbDrone.Mono.Test.EnvironmentInfo.ReleaseFileVersionAdapterFixture.should_get_version_info"

          # fails to start test dummy because it cannot locate .NET runtime for some reason
          "FullyQualifiedName!=NzbDrone.Common.Test.ProcessProviderFixture.should_be_able_to_start_process"
          "FullyQualifiedName!=NzbDrone.Common.Test.ProcessProviderFixture.exists_should_find_running_process"
          "FullyQualifiedName!=NzbDrone.Common.Test.ProcessProviderFixture.kill_all_should_kill_all_process_with_name"

          # makes real HTTP requests
          "FullyQualifiedName!~NzbDrone.Core.Test.TvTests.RefreshEpisodeServiceFixture"
          "FullyQualifiedName!~NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture"

          "FullyQualifiedName!=NzbDrone.Common.Test.ServiceFactoryFixture.event_handlers_should_be_unique"
        ]
        ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
          # fails on macOS
          "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture"
        ]
      )
    }"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) radarr;
    };

    updateScript = writers.writePython3 "radarr-updater" {
      libraries = with python3Packages; [ requests ];
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
    ];
    mainProgram = "Radarr";
    # platforms inherited from dotnet-sdk.
  };
}
