{
  lib,
  mkYarnPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  node-pre-gyp,
  python3,
  makeWrapper,
}:

mkYarnPackage rec {
  pname = "overseerr";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "sct";
    repo = "overseerr";
    rev = "v${version}";
    hash = "sha256-4332XsupUGjkFo0+4wn2fUyK5/y6EQoPaAuayBH/myk=";
  };

  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-f30P+/DxDz9uBmdgvaYK4YOAUmVce8MUnNHBXr8/yKc=";
  };

  env = {
    CYPRESS_INSTALL_BINARY = 0; # cypress tries to download binaries otherwise
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  # Fixes "SQLite package has not been found installed" at launch
  pkgConfig.sqlite3 = {
    nativeBuildInputs = [
      node-pre-gyp
      python3
    ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
      rm -r build-tmp-napi-v6
    '';
  };

  # Fixes MODULE_NOT_FOUND at launch.
  pkgConfig.bcrypt = {
    nativeBuildInputs = [
      node-pre-gyp
      python3
    ];
    postInstall = ''
      export CPPFLAGS="-I${nodejs}/include/node"
      node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
    '';
  };

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/overseerr" \
      --add-flags "$out/libexec/overseerr/deps/overseerr/dist/index.js" \
      --set NODE_ENV production
  '';

  buildPhase = ''
    runHook preBuild
    shopt -s dotglob
    pushd deps/overseerr
    rm -rf config/
    yarn --offline build
    rm -rf .next/cache
    popd
    runHook postBuild
  '';

  distPhase = "true";

  meta = {
    description = "Request management and media discovery tool for the Plex ecosystem";
    homepage = "https://github.com/sct/overseerr";
    license = lib.licenses.mit;
    mainProgram = "overseerr";
    maintainers = with lib.maintainers; [ jf-uu ];
  };
}
