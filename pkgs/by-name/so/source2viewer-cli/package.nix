{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {

  strictDeps = true;
  __structuredAttrs = true;

  pname = "source2viewer-cli";
  version = "19.1";

  src = fetchFromGitHub {
    owner = "ValveResourceFormat";
    repo = "ValveResourceFormat";
    tag = finalAttrs.version;
    hash = "sha256-eH/qAnStEjin/OM83JT1BfvWqwhjR0OoukIbAgxBNZU=";
  };

  projectFile = "CLI/CLI.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  nugetDeps = ./deps.json;

  executables = [ "Source2Viewer-CLI" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Parser, decompiler, and exporter for Valve's Source 2 resource file format (VRF)";
    homepage = "https://github.com/ValveResourceFormat/ValveResourceFormat";
    changelog = "https://github.com/ValveResourceFormat/ValveResourceFormat/releases/tag/${finalAttrs.version}";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.mit;
    mainProgram = "Source2Viewer-CLI";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cr0n ];
  };
})
