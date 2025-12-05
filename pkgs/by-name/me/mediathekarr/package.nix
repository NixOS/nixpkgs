{
  lib,
  stdenvNoCC,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  mkvtoolnix-cli,
  which,
  nix-update-script,
}:

let
  rid = dotnetCorePackages.systemToDotnetRid stdenvNoCC.hostPlatform.system;
in
buildDotnetModule rec {
  pname = "mediathekarr";
  version = "1.0-beta.9";

  src = fetchFromGitHub {
    owner = "PCJones";
    repo = "MediathekArr";
    rev = "8868c2b4bd2cc13b694418d64f5c42480b90ec9d";
    hash = "sha256-YsbgdP12pUep1okgvFeooj3VWhbfutp0gG4Nyf4Qjs8=";
  };

  projectFile = [
    "MediathekArr/MediathekArrDownloader.csproj"
    "MediathekArrServer/MediathekArrServer.csproj"
  ];
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  makeWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        mkvtoolnix-cli
        which
      ]
    }"
  ];

  installPhase = ''
    runHook preInstall

    dotnet publish MediathekArr/MediathekArrDownloader.csproj \
       -p:ContinuousIntegrationBuild=true \
       -p:Deterministic=true \
       -p:OverwriteReadOnlyFiles=true \
       --output "$out/lib/mediathekarr-downloader" \
       --configuration Release \
       --no-restore \
       --no-build \
       --runtime ${rid} \
       --no-self-contained \
       -p:PublishTrimmed=false \
       -p:UseAppHost=true


    dotnet publish MediathekArrServer/MediathekArrServer.csproj \
       -p:ContinuousIntegrationBuild=true \
       -p:Deterministic=true \
       -p:OverwriteReadOnlyFiles=true \
       --output "$out/lib/mediathekarr-server" \
       --configuration Release \
       --no-restore \
       --no-build \
       --runtime ${rid} \
       --no-self-contained \
       -p:PublishTrimmed=false \
       -p:UseAppHost=true

    runHook postInstall
  '';

  dontDotnetFixup = true;

  fixupPhase = ''
    runHook preFixup

    wrapDotnetProgram "$out/lib/mediathekarr-server/MediathekArrServer" "$out/bin/MediathekArrServer"
    wrapDotnetProgram "$out/lib/mediathekarr-downloader/MediathekArrDownloader" "$out/bin/MediathekArrDownloader"

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Integrate ARD&ZDF Mediathek in Prowlarr, Sonarr and Radarr";
    homepage = "https://github.com/PCJones/MediathekArr";
    changelog = "https://github.com/PCJones/MediathekArr/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      tmarkus
    ];
    platforms = lib.platforms.linux;
  };
}
