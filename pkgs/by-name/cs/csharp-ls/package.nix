{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
  versionCheckHook,
  nix-update-script,
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
in

buildDotnetGlobalTool rec {
  pname = "csharp-ls";
  version = "0.19.0";

  nugetHash = "sha256-Xd4DTSvhOyz+pqk4bpUCAz69WG5hby5yJsd/lO6Cs/Y=";

  inherit dotnet-sdk;
  dotnet-runtime = dotnet-sdk;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Roslyn-based LSP language server for C#";
    mainProgram = "csharp-ls";
    homepage = "https://github.com/razzmatazz/csharp-language-server";
    changelog = "https://github.com/razzmatazz/csharp-language-server/releases/tag/v${version}";
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
}
