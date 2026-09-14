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
}:
buildDotnetModule (finalAttrs: {
  pname = "cleanuparr";
  version = "2.10.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Cleanuparr";
    repo = "Cleanuparr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jaBAT3DWbsE5upQD4rERUVW/sb5Hu8pyuY7RdvhVDMs=";
  };

  transmission-api-rpc = callPackage ./transmission-api-rpc.nix { };
  qbittorrent-net-client = callPackage ./qbittorrent-net-client.nix { };

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
    npmHooks.npmConfigHook
    makeWrapper
  ];

  npmRoot = "code/frontend";

  npmDeps = fetchNpmDeps {
    name = "cleanuparr-npm-deps";
    src = "${finalAttrs.src}/code/frontend";
    hash = "sha256-HVA869ahw3PS9/a9JLhHS8KieioHAdRYjp2U47WcmVU=";
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
