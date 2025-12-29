{
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_8,
  dotnet-aspnetcore_8,
  nixosTests,
  lib,
  mediainfo,
  rhash,
  nix-update-script,
}:
buildDotnetModule (finalAttrs: {
  pname = "shoko";
  version = "5.1.0-dev.149";

  src = fetchFromGitHub {
    owner = "ShokoAnime";
    repo = "ShokoServer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZFCVNY8AOTesoB2FeOKszD6PGX4/BDudt6Lr/cGPrRM=";
    fetchSubmodules = true;
  };

  dotnet-sdk = dotnet-sdk_8;
  dotnet-runtime = dotnet-aspnetcore_8;

  nugetDeps = ./deps.json;
  projectFile = "Shoko.CLI/Shoko.CLI.csproj";
  dotnetBuildFlags = "/p:InformationalVersion=\"channel=stable\"";

  executables = [ "Shoko.CLI" ];
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${mediainfo}/bin"
  ];
  runtimeDeps = [ rhash ];

  passthru = {
    updateScript = nix-update-script { };
    tests.shoko = nixosTests.shoko;
  };

  meta = {
    homepage = "https://github.com/ShokoAnime/ShokoServer";
    changelog = "https://github.com/ShokoAnime/ShokoServer/releases/tag/v${finalAttrs.version}";
    description = "Backend for the Shoko anime management system";
    license = lib.licenses.mit;
    mainProgram = "Shoko.CLI";
    maintainers = with lib.maintainers; [
      diniamo
      nanoyaki
    ];
    inherit (dotnet-sdk_8.meta) platforms;
  };
})
