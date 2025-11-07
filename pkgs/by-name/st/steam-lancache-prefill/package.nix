{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  curl,
  jq,
  unzip,
}:

buildDotnetModule (finalAttrs: {
  pname = "steam-lancache-prefill";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "tpill90";
    repo = "steam-lancache-prefill";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6XBe64hAe5mPakjcTAPdwnMKsVlvCeorItLVS5cf+cI=";
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

  meta = {
    description = "Automatically fills a Lancache with games from Steam";
    homepage = "https://github.com/tpill90/steam-lancache-prefill";
    changelog = "https://github.com/tpill90/steam-lancache-prefill/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rhoriguchi ];
    mainProgram = "SteamPrefill";
    platforms = lib.platforms.all;
  };
})
