{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  testers,
}:

buildDotnetModule (finalAttrs: {
  pname = "seq-cli";
  version = "2025.2.02447";

  src = fetchFromGitHub {
    owner = "datalust";
    repo = "seqcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ghGd7divD+vLb8+4Z6fsQePxgQNEHME6KLPEo+EFnQI=";
  };

  projectFile = "src/SeqCli/SeqCli.csproj";
  nugetDeps = ./deps.json;
  dotnetInstallFlags = "-f net9.0";

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  executables = [ "seqcli" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "seqcli version";
  };

  meta = {
    description = "Seq command-line client. Administer, log, ingest, search, from any OS";
    homepage = "https://github.com/datalust/seqcli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hausken ];
    mainProgram = "seqcli";
    platforms = lib.platforms.all;
  };
})
