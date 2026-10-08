{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
  versionCheckHook,
  nix-update-script,
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
in

buildDotnetGlobalTool (finalAttrs: {
  pname = "csharp-ls";
  version = "0.27.0";

  nugetHash = "sha256-pJo01GZOT7pHgctQ1TfvrRdxOTgoNw4y7OP+deK87a8=";

  inherit dotnet-sdk;
  dotnet-runtime = dotnet-sdk;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Roslyn-based LSP language server for C#";
    mainProgram = "csharp-ls";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
