{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  nodejs_26,
  npmHooks,
  fetchNpmDeps,
  nix-update-script,
  dart-sass,
  makeWrapper,
  gcc,
}:
buildDotnetModule (finalAttrs: {
  pname = "cleanuparr";
  version = "2.11.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Cleanuparr";
    repo = "Cleanuparr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KMa8ePF682GnXRLuTL9SXYjLJDz14v5Geglk1vFL6vw=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  projectFile = "code/backend/Cleanuparr.Api/Cleanuparr.Api.csproj";

  executables = [ "Cleanuparr" ];

  nugetDeps = ./cleanuparr-deps.json;

  nativeBuildInputs = [
    nodejs_26
    nodejs_26.python
    dart-sass
    gcc
    (npmHooks.override { nodejs = nodejs_26; }).npmConfigHook
    makeWrapper
  ];

  npmRoot = "code/frontend";

  npmDeps = fetchNpmDeps {
    name = "cleanuparr-npm-deps";
    src = "${finalAttrs.src}/code/frontend";
    hash = "sha256-dVIrK9dplcG+T49AwlShOHZePbNumDwM94MQ+QMTIK4=";
  };

  preBuild = ''
    cd code/frontend
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail \
        'compilerCommand = (() => {' \
        'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
    npm run build
    cd ../..

    mkdir -p code/backend/Cleanuparr.Api/wwwroot
    cp -r code/frontend/dist/ui/browser/. code/backend/Cleanuparr.Api/wwwroot/
  '';

  postFixup = ''
    wrapProgram $out/bin/Cleanuparr \
      --chdir "$out/lib/cleanuparr"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

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
