{ version, src, stdenv, lib, fetchYarnDeps, fixup-yarn-lock, yarn, nodejs }:

stdenv.mkDerivation rec {
  inherit version src;

  pname = "rmfakecloud-webui";

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/ui/yarn.lock";
    sha256 = "sha256-JLCrpzytMKejmW+WlM6yybsoIZiimiJdPG5dSIn1L14=";
  };

  nativeBuildInputs = [ fixup-yarn-lock yarn nodejs ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    cd ui
    fixup-yarn-lock yarn.lock
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs node_modules
    export PATH=$PWD/node_modules/.bin:$PATH
    ./node_modules/.bin/react-scripts build
    mkdir -p $out
    cd ..
  '';

  installPhase = ''
    cp -r ui/build/* $out
  '';

  meta = with lib; {
    description = "Only the webui files for rmfakecloud";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
  };
}
