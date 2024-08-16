{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
  nix-update-script,
}:
let
  inherit (dotnetCorePackages) sdk_8_0;
in

buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.14.0";

  nugetHash = "sha256-agcx7VPIqGhl3NzdGLPwXYJsRuvSjL4SdbNg9vFjIh4=";

  dotnet-sdk = sdk_8_0;
  dotnet-runtime = sdk_8_0;

  passthru.tests = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Roslyn-based LSP language server for C#";
    mainProgram = "csharp-ls";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
