{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule {
  pname = "generate-answer-file";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "SvenGroot";
    repo = "GenerateAnswerFile";
    rev = "v2.2";
    hash = "sha256-RWC2VOrt5HCLL56bjdF33+KDGpA14QIlVyxWDYA012k=";
  };

  sourceRoot = "source/src";

  projectFile = [
    "GenerateAnswerFile/GenerateAnswerFile.csproj"
    "Ookii.AnswerFile/Ookii.AnswerFile.csproj"
  ];

  testProjectFile = "Ookii.AnswerFile.Tests/Ookii.AnswerFile.Tests.csproj";

  dotnet-sdk = dotnetCorePackages.combinePackages [
    dotnetCorePackages.sdk_8_0
    dotnetCorePackages.sdk_9_0
  ];
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  dotnetBuildFlags = [ "--framework net9.0" ];
  dotnetInstallFlags = [ "--framework net9.0" ];

  nugetDeps = ./deps.json;

  meta = {
    description = "CLI tool to generate answer files for Ookii.CommandLine";
    homepage = "https://github.com/SvenGroot/GenerateAnswerFile";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cairnstew ];
    platforms = lib.platforms.all;
  };
}
