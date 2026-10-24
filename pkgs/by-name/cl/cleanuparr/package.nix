{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nodejs_26,
  npmHooks,
  nix-update-script,
  fetchNpmDeps,
  callPackage,
  makeWrapper,
  gcc,
}:
buildDotnetModule (finalAttrs: {
  pname = "cleanuparr";
  version = "2.10.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Cleanuparr";
    repo = "Cleanuparr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NAq5z54xahcFxnNVDq1MHyhqMdqXQVfZDxVbfRht6MI=";
  };

  transmission-api-rpc = callPackage ./transmission-api-rpc.nix { };
  qbittorrent-net-client = callPackage ./qbittorrent-net-client.nix { };

  paths = [
    finalAttrs.transmission-api-rpc
    finalAttrs.qbittorrent-net-client
  ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  projectFile = "code/backend/Cleanuparr.Api/Cleanuparr.Api.csproj";

  executables = [ "Cleanuparr" ];

  nugetDeps = ./cleanuparr-deps.json;

  projectReferences = [
    finalAttrs.transmission-api-rpc
    finalAttrs.qbittorrent-net-client
  ];

  nativeBuildInputs = [
    nodejs_26
    nodejs_26.python
    gcc
    (npmHooks.override { nodejs = nodejs_26; }).npmConfigHook
    makeWrapper
  ];

  npmRoot = "code/frontend";

  npmDeps = fetchNpmDeps {
    name = "cleanuparr-npm-deps";
    src = "${finalAttrs.src}/code/frontend";
    hash = "sha256-Asc1QdoU0xAYmwgOkOycvtjDKsA+DMvy52GDW7VzBnA=";
  };

  preBuild = ''
    cd code/frontend
    npm run build
    cd ../..

    mkdir -p code/backend/Cleanuparr.Api/wwwroot
    cp -r code/frontend/dist/ui/browser/. code/backend/Cleanuparr.Api/wwwroot/
  '';

  postFixup = ''
    wrapProgram $out/bin/Cleanuparr \
      --chdir "$out/lib/cleanuparr"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced download manager for the Servarr ecosystem";
    homepage = "https://github.com/Cleanuparr/Cleanuparr";
    changelog = "https://github.com/Cleanuparr/Cleanuparr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mistyttm ];
    mainProgram = "Cleanuparr";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
