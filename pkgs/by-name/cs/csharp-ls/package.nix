{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
  versionCheckHook,
  nix-update-script,
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_11_0;
in

buildDotnetGlobalTool (finalAttrs: {
  pname = "csharp-ls";
  version = "0.29.0";

  nugetHash = "sha256-RhvzBw2WViVNH4gfZIRQKJF46geyYvWqOe8OdE6RxUM=";

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
