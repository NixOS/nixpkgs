{
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  lib,
  testers,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "empire-compiler";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "bc-security";
    repo = "empire-compiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k0y7pk79Az4lyXAcFP260T8WgCJSfxfaAtgsytC3wBw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;
  nugetDeps = ./deps.json;

  projectFile = "EmpireCompiler/EmpireCompiler.csproj";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "EmpireCompiler --version";
      version = "${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/BC-SECURITY/Empire-Compiler";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ [ "aarch64-darwin" ];
    description = "C# Compiler for Empire";
    maintainers = with lib.maintainers; [
      fzakaria
      vrose
    ];
  };
})
