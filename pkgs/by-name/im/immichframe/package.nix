{
  buildDotnetModule,
  dotnet-sdk_10,
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
  version = "1.0.40.0";

  src = fetchFromGitHub {
    owner = "immichFrame";
    repo = "immichFrame";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vPMRAa0ZcxR4jOT0zCTJHB6+PDpFnS6ngpyX5jz5Ce0=";
  };

  projectFile = "ImmichFrame.WebApi/ImmichFrame.WebApi.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnet-sdk_10;
  dotnet-runtime = dotnet-sdk_10.aspnetcore;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  npmRoot = "immichFrame.Web";

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/${finalAttrs.npmRoot}";
    hash = "sha256-tKX9adAfkdZ5aFD5tUoNUW+nyStYc+TBz0su2EC1uLA=";
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
    "--chdir"
    "${placeholder "out"}/lib/immichframe"
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
