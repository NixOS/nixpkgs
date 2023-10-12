{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, libkrb5
, zlib
, openssl
, callPackage
}:

buildDotnetModule rec {
  pname = "ArchiSteamFarm";
  # nixpkgs-update: no auto update
  version = "5.4.9.3";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ArchiSteamFarm";
    rev = version;
    hash = "sha256-Yp8hnMIeV+ZHY6yISJdFd1yAQipQsU5vcXgxFDvkGnA=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_7_0;
  dotnet-sdk = dotnetCorePackages.sdk_7_0;

  nugetDeps = ./deps.nix;

  projectFile = "ArchiSteamFarm.sln";
  executables = [ "ArchiSteamFarm" ];
  dotnetFlags = [
    "-p:PublishSingleFile=true"
    "-p:PublishTrimmed=true"
  ];
  dotnetInstallFlags = [
    "--framework=net7.0"
  ];
  selfContainedBuild = true;

  runtimeDeps = [ libkrb5 zlib openssl ];

  doCheck = true;

  preBuild = ''
    export projectFile=(ArchiSteamFarm)
  '';

  preInstall = ''
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
        --output $out/lib/archisteamfarm/plugins/$1 --configuration Release \
        -p:TargetLatestRuntimePatch=false -p:UseAppHost=false --no-restore \
        --framework=net7.0
     }

     buildPlugin ArchiSteamFarm.OfficialPlugins.ItemsMatcher
     buildPlugin ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
     buildPlugin ArchiSteamFarm.OfficialPlugins.SteamTokenDumper
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
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ SuperSandro2000 lom ];
  };
}
