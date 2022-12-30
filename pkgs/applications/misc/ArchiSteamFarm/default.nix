{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, libkrb5
, zlib
, openssl
, callPackage
, stdenvNoCC
}:

buildDotnetModule rec {
  pname = "archisteamfarm";
  # nixpkgs-update: no auto update
  version = "5.3.2.4";

  src = fetchFromGitHub {
    owner = "justarchinet";
    repo = pname;
    rev = version;
    sha256 = "sha256-qjU5TcYkAFJVYTOCwePGOVR9hYKNtinzLt5P4aTs578=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  nugetDeps = ./deps.nix;

  projectFile = "ArchiSteamFarm.sln";
  executables = [ "ArchiSteamFarm" ];
  dotnetFlags = [
    "-p:PublishSingleFile=true"
    "-p:PublishTrimmed=true"
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
      dotnet publish $1 -p:ContinuousIntegrationBuild=true -p:Deterministic=true \
        --output $out/lib/${pname}/plugins/$1 --configuration Release \
        -p:TargetLatestRuntimePatch=false -p:UseAppHost=false --no-restore
     }
     buildPlugin ArchiSteamFarm.OfficialPlugins.SteamTokenDumper
  '';

  passthru = {
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
