{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, libkrb5
, zlib
, openssl
, fetchpatch
}:

buildDotnetModule rec {
  pname = "archisteamfarm";
  version = "5.2.0.9";

  src = fetchFromGitHub {
    owner = "justarchinet";
    repo = pname;
    rev = version;
    sha256 = "sha256-BGd75l/p2rvRR/S8uz25aFws8txBpd60iB0xPbfTngM=";
  };

  dotnet-runtime = dotnetCorePackages.aspnetcore_6_0;
  dotnet-sdk = dotnetCorePackages.sdk_6_0;

  nugetDeps = ./deps.nix;

  projectFile = "ArchiSteamFarm.sln";
  executables = [ "ArchiSteamFarm" ];

  runtimeDeps = [ libkrb5 zlib openssl ];

  doCheck = true;

  preInstall = ''
    # A mutable path, with this directory tree must be set. By default, this would point at the nix store causing errors.
    makeWrapperArgs+=(
      --run "mkdir -p \"~/.config/archisteamfarm/{config,logs,plugins}\""
      --set "ASF_PATH" "~/.config/archisteamfarm"
    )
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    description = "Application with primary purpose of idling Steam cards from multiple accounts simultaneously";
    homepage = "https://github.com/JustArchiNET/ArchiSteamFarm";
    license = licenses.asl20;
    platforms = dotnetCorePackages.aspnetcore_5_0.meta.platforms;
    maintainers = with maintainers; [ SuperSandro2000 lom ];
  };
}
