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
  version = "0.22.0";

  nugetHash = "sha256-11ysfIiYnQG1vpfvmUWHuCR//rOLfYVRoQWedThojqc=";

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
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    badPlatforms = [
      # Crashes immediately at runtime
      # terminated by signal SIGKILL (Forced quit)
      # https://github.com/razzmatazz/csharp-language-server/issues/211
      "aarch64-darwin"
    ];
  };
})
