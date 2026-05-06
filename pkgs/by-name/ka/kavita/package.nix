{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  buildDotnetModule,
  buildNpmPackage,
  dotnetCorePackages,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kavita";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kareadita";
    repo = "kavita";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kFtzSOJYzPQf4QtdOLPLtRHIQj5nTZMB+cE42yZRTmc=";
  };

  backend = buildDotnetModule {
    pname = "kavita-backend";
    inherit (finalAttrs) version src;

    patches = [
      # The webroot is hardcoded as ./wwwroot
      ./change-webroot.diff
      # NOTE: Upstream frequently removes old database migrations between versions.
      # Currently no migration patches are needed for upgrades from NixOS 24.11 (v0.8.3.2).
      # Future updates should check if migration restoration is needed for supported upgrade paths.
    ];
    postPatch = ''
      substituteInPlace Kavita.Services/DirectoryService.cs --subst-var out

      substituteInPlace Kavita.Server/Startup.cs Kavita.Services/LocalizationService.cs Kavita.Server/Controllers/FallbackController.cs \
        --subst-var-by webroot "${finalAttrs.frontend}/lib/node_modules/kavita-webui/dist/browser"
    '';

    #executables = [ "Kavita.Server/API" ];

    projectFile = "Kavita.Server/Kavita.Server.csproj";
    nugetDeps = ./nuget-deps.json;
    dotnet-sdk = dotnetCorePackages.sdk_10_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;
  };

  frontend = buildNpmPackage {
    pname = "kavita-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/UI/Web";

    npmBuildScript = "prod";
    npmFlags = [ "--legacy-peer-deps" ];
    npmRebuildFlags = [ "--ignore-scripts" ]; # Prevent playwright from trying to install browsers
    npmDepsHash = "sha256-Qa/lf0hH2KMDdRcBj8GW9cJGE3YZsP32z2kfTk6YNYc=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/kavita
    ln -s $backend/lib/kavita-backend $out/lib/kavita/backend
    ln -s $frontend/lib/node_modules/kavita-webui/dist $out/lib/kavita/frontend
    ln -s $backend/bin/Kavita.Server $out/bin/kavita

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests) kavita;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fast, feature rich, cross platform reading server";
    homepage = "https://kavitareader.com";
    changelog = "https://github.com/kareadita/kavita/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      misterio77
      nevivurn
    ];
    mainProgram = "kavita";
  };
})
