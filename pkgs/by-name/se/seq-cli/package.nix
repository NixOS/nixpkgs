{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  testers,
}:

buildDotnetModule (finalAttrs: {
  pname = "seq-cli";
  version = "2024.3.922";

  src = fetchFromGitHub {
    owner = "datalust";
    repo = "seqcli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qqvuxG/QkkYjYw+p5QxLBWYHyltKDWT3JT167bEAdEI=";
  };

  projectFile = "src/SeqCli/SeqCli.csproj";
  nugetDeps = ./deps.json;
  dotnetInstallFlags = "-f net8.0";

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "seqcli" ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "seqcli version";
  };

  meta = {
    description = "The Seq command-line client. Administer, log, ingest, search, from any OS";
    homepage = "https://github.com/datalust/seqcli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hausken ];
    mainProgram = "seqcli";
    platforms = lib.platforms.all;
  };
})
