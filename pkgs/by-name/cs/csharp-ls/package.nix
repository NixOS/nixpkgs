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
  version = "0.15.0";

  nugetHash = "sha256-Fp1D2z4x2e85z4IO4xQentS7dbqhFT3e/BPZm0d5L5M=";

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
