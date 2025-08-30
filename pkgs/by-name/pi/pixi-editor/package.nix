{
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:
buildDotnetModule {
  pname = "pixi-editor";
  version = "2.0.1.3";

  src = fetchFromGitHub {
    owner = "PixiEditor";
    repo = "PixiEditor";
    tag = "2.0.1.3";
    fetchSubmodules = true;
    hash = "sha256-0dCRvzbBjdRpKgoa5Y3z+pAU6PHnWMXaYihRLQYpGSE=";
  };

  projectFile = "src/PixiEditor.Desktop/PixiEditor.Desktop.csproj";

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
}
