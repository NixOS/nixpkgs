{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  versionCheckHook,
}:

buildDotnetModule (finalAttrs: {
  pname = "officecli";
  version = "1.0.92";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g4eCgVqlW3N+pwATIsZbmjWNQ4IScUv9e40eUH9rfQw=";
  };

  projectFile = "src/officecli/officecli.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  selfContainedBuild = true;
  executables = [ "officecli" ];

  makeWrapperArgs = [
    "--set"
    "OFFICECLI_SKIP_UPDATE"
    "1"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Command-line tool for creating, reading and editing Office documents";
    homepage = "https://github.com/iOfficeAI/OfficeCLI";
    changelog = "https://github.com/iOfficeAI/OfficeCLI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "officecli";
    maintainers = with lib.maintainers; [ qrzbing ];
    platforms = finalAttrs.dotnet-sdk.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
