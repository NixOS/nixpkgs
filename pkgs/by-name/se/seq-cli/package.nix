{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  testers,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "seq-cli";
  version = "2026.1.02662";

  src = fetchFromGitHub {
    owner = "datalust";
    repo = "seqcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vvcYT1u3+puJVZ/LoxiOpLIsk17bnRB8/ivzCPfPj5U=";
  };

  projectFile = "src/SeqCli/SeqCli.csproj";
  nugetDeps = ./deps.json;
  dotnetInstallFlags = "-f net10.0";

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  executables = [ "seqcli" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "seqcli version";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Seq command-line client. Administer, log, ingest, search, from any OS";
    homepage = "https://github.com/datalust/seqcli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hausken ];
    mainProgram = "seqcli";
    platforms = lib.platforms.all;
  };
})
