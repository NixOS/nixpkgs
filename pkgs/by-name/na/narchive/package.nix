{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "narchive";
  version = "1.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nickworonekin";
    repo = "narchive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NidYpFIKm9j5krFRioSWegBkSoL3ixrfLWzmVF/Xc58=";
  };

  doCheck = false;

  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  dotnetFlags = [ "-p:TargetFramework=net10.0" ];

  executables = [ "Narchive" ];
  nugetDeps = ./deps.json;
  projectFile = "src/Narchive/Narchive.csproj";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for creating and extracting NARC archives used in Nintendo DS games";
    homepage = "https://github.com/nickworonekin/narchive";
    changelog = "https://github.com/nickworonekin/narchive/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "Narchive";
  };
})
