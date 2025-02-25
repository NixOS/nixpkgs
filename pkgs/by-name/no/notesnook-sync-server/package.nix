{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  gitUpdater,
}:

buildDotnetModule rec {
  pname = "notesnook-sync-server";
  version = "1.0-beta.1";

  src = fetchFromGitHub {
    owner = "streetwriters";
    repo = "notesnook-sync-server";
    tag = "v${version}";
    hash = "sha256-A2RM/1k9YAwal2MUEfuZMJU9ixf0jOH0rj3JPnGdgws=";
  };

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  dotnetBuildFlags = [
    # fix for "The process cannot access the file '...deps.json' because it is being used by another process."
    "/maxcpucount:1"
  ];

  executables = [
    "Notesnook.API"
    "Streetwriters.Identity"
    "Streetwriters.Messenger"
  ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (gitUpdater { }).command
    (passthru.fetch-deps)
  ];

  meta = {
    description = "Sync server for Notesnook (self-hosting in alpha)";
    homepage = "https://github.com/streetwriters/notesnook-sync-server";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.linux;
  };
}
