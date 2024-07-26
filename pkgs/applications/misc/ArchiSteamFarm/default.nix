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
  version = "6.0.3.4";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ArchiSteamFarm";
    rev = version;
    hash = "sha256-qYB94SJYCwcUrXdKtD+ZdiPRpwXg3rOHVmFWD+Y1ZXg=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  nugetDeps = ./deps.nix;

  projectFile = "ArchiSteamFarm.sln";
  executable = "ArchiSteamFarm";
  dotnetFlags = [
    "-p:UseAppHost=false"
  ];
  dotnetInstallFlags = [
    "--framework=net8.0"
  ];

  runtimeDeps = [ libkrb5 zlib openssl ];

  doCheck = true;

  preBuild = ''
    dotnetProjectFiles=(ArchiSteamFarm)
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
        --output $out/lib/ArchiSteamFarm/plugins/$1 --configuration Release \
        -p:UseAppHost=false
    }

    buildPlugin ArchiSteamFarm.OfficialPlugins.ItemsMatcher
    buildPlugin ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
    buildPlugin ArchiSteamFarm.OfficialPlugins.Monitoring
    buildPlugin ArchiSteamFarm.OfficialPlugins.SteamTokenDumper

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
