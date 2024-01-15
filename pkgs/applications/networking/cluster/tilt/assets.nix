{ lib
, stdenvNoCC
, version, src
, fetchYarnDeps
, prefetch-yarn-deps, yarn, nodejs
}:

stdenvNoCC.mkDerivation rec {
  pname = "tilt-assets";

  inherit src version;

  nativeBuildInputs = [ prefetch-yarn-deps yarn nodejs ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/web/yarn.lock";
    hash = "sha256-UTxglGn3eIgahZg4kxolg2f2MTReCL4r/GyWNg4105E=";
  };

  configurePhase = ''
    export HOME=$(mktemp -d)/yarn_home
  '';

  buildPhase = ''
    runHook preBuild

    yarn config --offline set yarn-offline-mirror $yarnOfflineCache

    cd web
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-engines
    patchShebangs node_modules
    export PATH=$PWD/node_modules/.bin:$PATH
    ./node_modules/.bin/react-scripts build

    mkdir -p $out
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    cp -r web/build/* $out
  '';

  meta = with lib; {
    description = "Assets needed for Tilt";
    homepage = "https://tilt.dev/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anton-dessiatov ];
    platforms = platforms.all;
  };
}
