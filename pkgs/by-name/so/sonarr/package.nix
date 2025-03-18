{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, sqlite
, withFFmpeg ? true # replace bundled ffprobe binary with symlink to ffmpeg package.
, ffmpeg
, fetchYarnDeps
, yarn
, fixup-yarn-lock
, nodejs
, nixosTests
  # update script
, writers
, python3Packages
, nix
, prefetch-yarn-deps
}:
let
  version = "4.0.8.1874";
  src = fetchFromGitHub {
    owner = "Sonarr";
    repo = "Sonarr";
    rev = "v${version}";
    hash = "sha256-4WjeuVqzuUmgbKIjcQOJCNrTnT9Wn6kpVxS+1T1hqyQ=";
  };
in
buildDotnetModule {
  pname = "sonarr";
  inherit version src;

  patches = [
    ./nuget-config.patch
  ];

  strictDeps = true;
  nativeBuildInputs = [ nodejs yarn prefetch-yarn-deps fixup-yarn-lock ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-dSZBifvUGJx5lj7C+Sj+kJprK8JG6SE5vg6+X6QdCZ8=";
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
  postInstall = lib.optionalString withFFmpeg ''
    rm -- "$out/lib/sonarr/ffprobe"
    ln -s -- "$ffprobe" "$out/lib/sonarr/ffprobe"
  '' + ''
    cp -a -- _output/UI "$out/lib/sonarr/UI"
  '';
  # Add an alias for compatibility with Sonarr v3 package.
  postFixup = ''
    ln -s -- Sonarr "$out/bin/NzbDrone"
  '';

  nugetDeps = ./deps.nix;

  runtimeDeps = [ sqlite ];

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

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
    "--property:TargetFramework=net6.0"
    "--property:EnableAnalyzers=false"
    # Override defaults in src/Directory.Build.props that use current time.
    "--property:Copyright=Copyright 2014-2024 sonarr.tv (GNU General Public v3)"
    "--property:AssemblyVersion=${version}"
    "--property:AssemblyConfiguration=main"
  ];

  # Skip manual, integration, automation and platform-dependent tests.
  dotnetTestFlags = [
    "--filter:${lib.concatStringsSep "&" [
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

      # fails on macOS
      "FullyQualifiedName!~NzbDrone.Core.Test.Http.HttpProxySettingsProviderFixture"
    ]}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) sonarr;
    };

    updateScript = writers.writePython3 "sonarr-updater"
      {
        libraries = with python3Packages; [ requests ];
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath [ nix prefetch-yarn-deps ])
        ];
      }
      ./update.py;
  };

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = "https://sonarr.tv";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fadenb purcell tie ];
    mainProgram = "Sonarr";
    # platforms inherited from dotnet-sdk.
  };
}
