{
  buildDotnetModule,
  dotnet-sdk,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nixosTests,
  nodejs,
  npmHooks,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "immichframe";
  version = "1.0.35.0";

  src = fetchFromGitHub {
    owner = "immichFrame";
    repo = "immichFrame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VET0em+CyJzXPlCXjozj6SDhjD26lH94AETFKGG895I=";
  };

  projectFile = "ImmichFrame.WebApi/ImmichFrame.WebApi.csproj";
  nugetDeps = ./deps.json;
  dotnet-runtime = dotnet-sdk.aspnetcore;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  npmRoot = "immichFrame.Web";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-RyMY5ooC6Q+W+Y24ILv+WCcWLMDToZ52yefFuoAYubY=";
  };

  preBuild = ''
    pushd ${finalAttrs.npmRoot}
    npm run build
    popd
  '';

  postInstall = ''
    cp -r ${finalAttrs.npmRoot}/build/* $out/lib/immichframe/wwwroot/
  '';

  makeWrapperArgs = [
    "--chdir ${placeholder "out"}/lib/immichframe"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) immichframe; };
  };

  meta = {
    changelog = "https://github.com/immichFrame/ImmichFrame/releases/tag/${finalAttrs.src.tag}";
    description = "Display your photos from Immich as a digital photo frame";
    homepage = "https://immichframe.dev";
    license = lib.licenses.gpl3Only;
    mainProgram = "ImmichFrame.WebApi";
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
})
