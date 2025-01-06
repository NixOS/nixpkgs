{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  curl,
  jq,
  unzip,
}:

buildDotnetModule rec {
  pname = "steam-lancache-prefill";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "steam-lancache-prefill";
    rev = "v${version}";
    hash = "sha256-tXGJ91XacdB4RyGf5DmiYAvkCw1g5gD9n0wO/+1pjaI=";
    fetchSubmodules = true;
  };

  projectFile = "SteamPrefill/SteamPrefill.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  executables = [ "SteamPrefill" ];

  patches = [ ./current-dir-config.patch ];

  nativeBuildInputs = [
    curl
    jq
    unzip
  ];

  postInstall = ''
    rm -rf $out/lib/steam-lancache-prefill/update.sh
  '';

  meta = with lib; {
    description = "Automatically fills a Lancache with games from Steam";
    homepage = "https://github.com/tpill90/steam-lancache-prefill";
    changelog = "https://github.com/tpill90/steam-lancache-prefill/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
    mainProgram = "SteamPrefill";
    platforms = platforms.all;
  };
}
