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
  version = "4.0.15.2941";
  # The dotnet8 compatibility patches also change `yarn.lock`, so we must pass
  # the already patched lockfile to `fetchYarnDeps`.
  src = applyPatches {
    src = fetchFromGitHub {
      owner = "Sonarr";
      repo = "Sonarr";
      tag = "v${version}";
      hash = "sha256-1lBUkodBDFpJD7pyHAFb8HRLrbK8wyAboX0A2oBQnTM=";
    };
    postPatch = ''
      mv src/NuGet.Config NuGet.Config
    '';
    patches = lib.optionals (lib.versionOlder version "5.0") [
      # See https://github.com/Sonarr/Sonarr/issues/7442 and
      # https://github.com/Sonarr/Sonarr/pull/7443.
      # Unfortunately, the .NET 8 upgrade was only merged into the v5 branch,
      # and it may take some time for that to become stable.
      # However, the patches cleanly apply to v4 as well.
      (fetchpatch {
        name = "dotnet8-compatibility";
        url = "https://github.com/Sonarr/Sonarr/commit/518f1799dca96a7481004ceefe39be465de3d72d.patch";
        hash = "sha256-e+/rKZrTf6lWq9bmCAwnZrbEPRkqVmI7qNavpLjfpUE=";
      })
      (fetchpatch {
        name = "dotnet8-darwin-compatibility";
        url = "https://github.com/Sonarr/Sonarr/commit/1a5fa185d11d2548f45fefb8a0facd3731a946d0.patch";
        hash = "sha256-6Lzo4ph1StA05+B1xYhWH+BBegLd6DxHiEiaRxGXn7k=";
      })
    ];
  };
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule {
  pname = "sonarr";
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
    hash = "sha256-YkBFvv+g4p22HdM/GQAHVGGW1yLYGWpNtRq7+QJiLIw=";
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
      rm -- "$out/lib/sonarr/ffprobe"
      ln -s -- "$ffprobe" "$out/lib/sonarr/ffprobe"
    ''
    + ''
      cp -a -- _output/UI "$out/lib/sonarr/UI"
    '';
  # Add an alias for compatibility with Sonarr v3 package.
  postFixup = ''
    ln -s -- Sonarr "$out/bin/NzbDrone"
  '';

  nugetDeps = ./deps.json;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  doCheck = true;

  __darwinAllowLocalNetworking = true; # for tests

  __structuredAttrs = true; # for Copyright property that contains spaces

  executables = [ "Sonarr" ];

  projectFile = [
    "src/NzbDrone.Console/Sonarr.Console.csproj"
    "src/NzbDrone.Mono/Sonarr.Mono.csproj"
  ];

  testProjectFile = [
    "src/NzbDrone.Api.Test/Sonarr.Api.Test.csproj"
    "src/NzbDrone.Common.Test/Sonarr.Common.Test.csproj"
    "src/NzbDrone.Core.Test/Sonarr.Core.Test.csproj"
    "src/NzbDrone.Host.Test/Sonarr.Host.Test.csproj"
    "src/NzbDrone.Libraries.Test/Sonarr.Libraries.Test.csproj"
    "src/NzbDrone.Mono.Test/Sonarr.Mono.Test.csproj"
    "src/NzbDrone.Test.Common/Sonarr.Test.Common.csproj"
  ];

  dotnetFlags = [
    "--property:TargetFramework=net8.0"
    "--property:EnableAnalyzers=false"
    "--property:SentryUploadSymbols=false" # Fix Sentry upload failed warnings
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2025 sonarr.tv (GNU General Public v3)"
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
          "FullyQualifiedName!=NzbDrone.Common.Test.ProcessProviderFixture.Should_be_able_to_start_process"
          "FullyQualifiedName!=NzbDrone.Common.Test.ProcessProviderFixture.kill_all_should_kill_all_process_with_name"

          # makes real HTTP requests
          "FullyQualifiedName!~NzbDrone.Core.Test.TvTests.RefreshEpisodeServiceFixture"
          "FullyQualifiedName!~NzbDrone.Core.Test.UpdateTests.UpdatePackageProviderFixture"
        ]
        ++ lib.optionals stdenvNoCC.buildPlatform.isDarwin [
          # fails on macOS
          "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture"
          "FullyQualifiedName!=NzbDrone.Common.Test.ServiceFactoryFixture.event_handlers_should_be_unique"
        ]
      )
    }"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) sonarr;
    };

    updateScript = writers.writePython3 "sonarr-updater" {
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
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = "https://sonarr.tv";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      fadenb
      purcell
      tie
      niklaskorz
    ];
    mainProgram = "Sonarr";
    # platforms inherited from dotnet-sdk.
  };
}
