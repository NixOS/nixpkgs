{ lib
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
  version = "5.3.1.2";

  src = fetchFromGitHub {
    owner = "justarchinet";
    repo = pname;
    rev = version;
    sha256 = "sha256-plimvkMUjQWQ0Ewm1TXL5IB1xe62DFhwBlBc4UeCguU=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;

  nugetDeps = ./deps.nix;

  # Without this dotnet attempts to restore for Windows targets, which it cannot find the dependencies for
  dotnetRestoreFlags = [ "--runtime ${dotnetCorePackages.sdk_6_0.systemToDotnetRid stdenvNoCC.targetPlatform.system}" ];

  projectFile = "ArchiSteamFarm.sln";
  executables = [ "ArchiSteamFarm" ];

  runtimeDeps = [ libkrb5 zlib openssl ];

  doCheck = true;

  preInstall = ''
    # A mutable path, with this directory tree must be set. By default, this would point at the nix store causing errors.
    makeWrapperArgs+=(
      --run 'mkdir -p ~/.config/archisteamfarm/{config,logs,plugins}'
      --set "ASF_PATH" "~/.config/archisteamfarm"
    )
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
