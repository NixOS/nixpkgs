{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  libkrb5,
  zlib,
  openssl,
  callPackage,
}:

let
  plugins = [
    "ArchiSteamFarm.OfficialPlugins.ItemsMatcher"
    "ArchiSteamFarm.OfficialPlugins.MobileAuthenticator"
    "ArchiSteamFarm.OfficialPlugins.Monitoring"
    "ArchiSteamFarm.OfficialPlugins.SteamTokenDumper"
  ];
in
buildDotnetModule rec {
  pname = "ArchiSteamFarm";
  # nixpkgs-update: no auto update
  version = "6.2.0.5";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ArchiSteamFarm";
    rev = version;
    hash = "sha256-CNnSsFBeO3BHUbom0eytfz02Q7QBv8JEmHbgPSL7I3Y=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  nugetDeps = ./deps.json;

  projectFile = [
    "ArchiSteamFarm"
  ]
  ++ plugins;
  testProjectFile = "ArchiSteamFarm.Tests";

  executable = "ArchiSteamFarm";

  enableParallelBuilding = false;

  useAppHost = false;
  dotnetFlags = [
    # useAppHost doesn't explicitly disable this
    "-p:UseAppHost=false"
    "-p:RuntimeIdentifiers="
  ];
  dotnetBuildFlags = [
    "--framework=net9.0"
  ];
  dotnetInstallFlags = dotnetBuildFlags;

  runtimeDeps = [
    libkrb5
    zlib
    openssl
  ];

  doCheck = true;

  preInstall = ''
    dotnetProjectFiles=(ArchiSteamFarm)

    # A mutable path, with this directory tree must be set. By default, this would point at the nix store causing errors.
    makeWrapperArgs+=(
      --run 'mkdir -p ~/.config/archisteamfarm/{config,logs,plugins}'
      --set "ASF_PATH" "~/.config/archisteamfarm"
    )
  '';

  postInstall = ''
    buildPlugin() {
      echo "Publishing plugin $1"
      dotnet publish $1 -p:ContinuousIntegrationBuild=true -p:Deterministic=true \
        --output $out/lib/ArchiSteamFarm/plugins/$1 --configuration Release \
        --no-restore --no-build --runtime $dotnetRuntimeIds \
        $dotnetFlags $dotnetInstallFlags
    }

  ''
  + lib.concatMapStrings (p: "buildPlugin ${p}\n") plugins
  + ''

    chmod +x $out/lib/ArchiSteamFarm/ArchiSteamFarm.dll
    wrapDotnetProgram $out/lib/ArchiSteamFarm/ArchiSteamFarm.dll $out/bin/ArchiSteamFarm
    substituteInPlace $out/bin/ArchiSteamFarm \
      --replace-fail "exec " "exec dotnet "
  '';

  passthru = {
    # nix-shell maintainers/scripts/update.nix --argstr package ArchiSteamFarm
    updateScript = ./update.sh;
    ui = callPackage ./web-ui { };
  };

  meta = with lib; {
    description = "Application with primary purpose of idling Steam cards from multiple accounts simultaneously";
    homepage = "https://github.com/JustArchiNET/ArchiSteamFarm";
    license = licenses.asl20;
    mainProgram = "ArchiSteamFarm";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
