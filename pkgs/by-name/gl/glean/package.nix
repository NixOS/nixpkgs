{
  lib,
  buildGoModule,
  fetchFromGitHub,
  npmHooks,
  nodejs,
  fetchNpmDeps,
  pkg-config,
  gtk3,
  webkitgtk_4_1,
}:

buildGoModule (finalAttrs: {
  pname = "glean";
  version = "1.5.0";

  __structuredAttrs = true;

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
    pkg-config
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
  ];

  preBuild = ''
    pushd frontend
    npm run build
    popd
  '';

  meta = {
    description = "Note-taking app with a constellation-based night-sky UI";
    homepage = "https://github.com/rokuroo171/glean";
    license = lib.licenses.gpl3Only;
    mainProgram = "glean";
    maintainers = with lib.maintainers; [ rokuroo171 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
