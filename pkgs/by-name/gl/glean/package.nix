{
  lib,
  buildGoModule,
  fetchFromGitHub,
  npmHooks,
  nodejs,
  fetchNpmDeps,
}:

buildGoModule (finalAttrs: {
  pname = "glean";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rokuroo171";
    repo = "glean";
    tag = "v${finalAttrs.version}";
    hash = "sha256-frdwT4wodBHOAChOxXhzLwDNOON03YtWBy19wWtZZTQ=";
  };

  vendorHash = "sha256-0wokAwAd41GL/KK339fnmjQa8/mEeySg8J2Pcn+lmP8=";

  npmDeps = fetchNpmDeps {
    name = "glean-frontend-deps";
    src = "${finalAttrs.src}/frontend";
    hash = "sha256-MOEW3oPuZuQq/xR6fnNs0/yKtbFsH6d56aY8OGJ0ZuE=";
  };

  npmRoot = "frontend";

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  preBuild = ''
    cd frontend
    npm run build
    cd ..
  '';

  meta = {
    description = "An open-source note-taking app with lots of customization";
    homepage = "https://github.com/rokuroo171/glean";
    license = lib.licenses.gpl3Plus;
    mainProgram = "glean";
    maintainers = with lib.maintainers; [ rokuroo171 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ sourceFromBuild ];
  };
})
