{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
}:
buildDotnetModule (finalAttrs: {
  pname = "fracjson";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "j-brooke";
    repo = "FracturedJson";
    tag = "cli-v${finalAttrs.version}";
    sha256 = "sha256-NV2IgupvCl1Q3C9T37ZjiE5/6Y4zRHLF1367cUseI8k=";
  };

  patchPhase = ''
    substituteInPlace Cli/Cli.csproj \
    --replace-fail '<TargetFramework>net8.0</' '<TargetFramework>net11.0</'
  '';

  projectFile = "Cli/Cli.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_11_0;
  dotnet-runtime = dotnetCorePackages.runtime_11_0;

  # Compression in single-file bundles requires self-contained builds;
  # override the .csproj setting for framework-dependent Nix packaging.
  dotnetInstallFlags = [ "-p:EnableCompressionInSingleFile=false" ];

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "JSON formatter that produces compact, highly readable output";
    homepage = "https://github.com/j-brooke/FracturedJson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ allsimon ];
    platforms = lib.platforms.all;
  };
})
