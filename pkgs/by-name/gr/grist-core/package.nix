{ lib, stdenv, fetchFromGitHub, fetchYarnDeps, mkYarnPackage, mkYarnModules
, yarn, python3, sqlite, nodejs, gvisor, coreutils
}: let

  pname = "grist-core";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "gristlabs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pEcH0skMf/3/dckcPNG8VM/QMwrkKjkU8FllpJjXkQs=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-TxyQdI/tP7q6kevMQJbnXmaVhBiFOK+9C10feNupGxs=";
  };

in stdenv.mkDerivation {

  inherit pname version src;
  nativeBuildInputs = [
    yarn nodejs python3
    ## for @gristlabs/sqlite3
    nodejs.pkgs.node-pre-gyp
  ];
  buildInputs = [
    ## for @gristlabs/sqlite3
    sqlite
  ];

  preUnpack = ''
    export HOME=$NIX_BUILD_TOP/yarn_home
  '';

  patchPhase = ''
    patchShebangs buildtools/*
    # Do not look up in the registry, but in the offline cache.
    # TODO: Ask upstream to fix this mess. see yarn2nix-moretea
    sed -i -E '/resolved /{s|https://registry.yarnpkg.com/||;s|[@/:-]|_|g}' yarn.lock
    rm .yarnrc
  '';

  configurePhase = ''
    yarn config --offline set yarn-offline-mirror ${offlineCache}
  '';

  buildPhase = ''
    yarn install --offline --frozen-lockfile --ignore-scripts
    patchShebangs node_modules/*/bin/*
    ( cd node_modules/@gristlabs/sqlite3
      CPPFLAGS="-I${nodejs}/include/node" node-pre-gyp install \
        --prefer-offline --build-from-source \
        --nodedir=${nodejs}/include/node --sqlite=${sqlite.dev}
      rm -r build-tmp-napi-v6 )
    yarn --offline build:prod
  '';
  ## FIXME cannot prune despite 300M savings:
  ## Error: Cannot find module 'chokidar'
  # npm prune --omit=dev

  installPhase = ''
    mkdir -p $out/libexec $out/bin
    cp -R . $out/libexec/grist
    substitute ${./grist-run.sh.in} $out/bin/grist-run \
      --subst-var-by gristOut $out/libexec/grist \
      --subst-var-by path ${lib.makeBinPath [ nodejs coreutils gvisor ]}
    chmod +x $out/bin/grist-run
  '';

}
