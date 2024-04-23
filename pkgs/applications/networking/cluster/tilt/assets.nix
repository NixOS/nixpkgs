{ lib
, stdenvNoCC
, version, src
, yarn-berry, callPackage
, nodejs
}:

stdenvNoCC.mkDerivation rec {
  pname = "tilt-assets";

  inherit src version;

  nativeBuildInputs = [ yarn-berry nodejs ];

  /*
  Introduced as a temporary hack until 'fetchYarnDeps' is fixed to
  accommodate yarn berry lockfiles:
  https://github.com/NixOS/nixpkgs/issues/254369
  */
  yarnOfflineCache = callPackage ./yarn.nix {
    inherit src;
    hash = "sha256-Z5sTVFyfSVw5soLj7mGjYMWT+51KVqjeaVqKsVD5IUg=";
  };

  configurePhase = ''
    export HOME=$(mktemp -d)/yarn_home
  '';

  buildPhase = ''
    runHook preBuild

    cd web

    export YARN_ENABLE_TELEMETRY=0
    ln -sf $yarnOfflineCache /build/source/web/.yarn/cache
    yarn install --immutable --immutable-cache

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
