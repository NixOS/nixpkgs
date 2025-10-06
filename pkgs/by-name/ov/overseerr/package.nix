{
  fetchFromGitHub,
  fetchYarnDeps,
  lib,
  makeWrapper,
  node-gyp,
  node-pre-gyp,
  nodejs,
  python3,
  stdenv,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation rec {
  pname = "overseerr";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "sct";
    repo = "overseerr";
    tag = "v${version}";
    hash = "sha256-4332XsupUGjkFo0+4wn2fUyK5/y6EQoPaAuayBH/myk=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-f30P+/DxDz9uBmdgvaYK4YOAUmVce8MUnNHBXr8/yKc=";
  };

  env.CYPRESS_INSTALL_BINARY = 0;

  nativeBuildInputs = [
    makeWrapper
    node-gyp
    node-pre-gyp
    nodejs
    python3
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  postInstall = ''
    # Fixes "Error: Cannot find module" (bcrypt) and "SQLite package has not been found installed".
    pushd $out/lib/node_modules/overseerr/node_modules
    for module in bcrypt sqlite3; do
      pushd $module
      node-pre-gyp rebuild --build-from-source --nodedir=${nodejs} --prefer-offline
      popd
    done

    makeWrapper "${lib.getExe nodejs}" "$out/bin/overseerr" \
      --set NODE_ENV production \
      --chdir "$out/lib/node_modules/overseerr" \
      --add-flags "dist/index.js" \
      --add-flags "--"
  '';

  meta = {
    badPlatforms = [
      # FileNotFoundError: [Errno 2] No such file or directory: 'xcodebuild'
      lib.systems.inspect.patterns.isDarwin
    ];
    changelog = "https://github.com/sct/overseerr/releases/tag/v${version}";
    description = "Request management and media discovery tool for the Plex ecosystem";
    homepage = "https://github.com/sct/overseerr";
    license = lib.licenses.mit;
    mainProgram = "overseerr";
    maintainers = with lib.maintainers; [ jf-uu ];
  };
}
