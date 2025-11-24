{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  versionCheckHook,
  nix-update-script,
}:

buildDotnetModule rec {
  pname = "sbom-tool";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "sbom-tool";
    tag = "v${version}";
    hash = "sha256-3MeiTGywX9ummmmJRRy7JrOiP06lwY7B5wlWwN39w7c=";
  };

  projectFile = "src/Microsoft.Sbom.Tool/Microsoft.Sbom.Tool.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetBuildFlags = [
    "-p:MinVerVersionOverride=${version}"
  ];

  dotnetInstallFlags = [
    "--framework"
    "net8.0"
  ];

  executables = [ "Microsoft.Sbom.Tool" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Highly scalable and enterprise ready tool to create SPDX 2.2 and SPDX 3.0 compatible SBOMs for any variety of artifacts";
    homepage = "https://github.com/microsoft/sbom-tool";
    changelog = "https://github.com/microsoft/sbom-tool/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "Microsoft.Sbom.Tool";
  };
}
