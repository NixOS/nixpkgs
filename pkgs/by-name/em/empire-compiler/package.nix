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
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bc-security";
    repo = "empire-compiler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hquqUEQHdID+2dTWiSkMjcYi4wc6KlSllAD9vUzdH10=";
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
