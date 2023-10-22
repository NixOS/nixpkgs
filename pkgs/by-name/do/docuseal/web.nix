{ lib
, stdenv
, fetchYarnDeps
, yarn
, prefetch-yarn-deps
, nodejs
, which
, version
, src
, meta
, rubyEnv
}:
stdenv.mkDerivation {
  pname = "docuseal-web";
  inherit version src meta;

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-7u8VuOhoxEt9Hs5Eb3hzP3g/fMuyqQfZEbDLek26Lbk=";
  };

  nativeBuildInputs = [
    yarn
    prefetch-yarn-deps
    nodejs
    rubyEnv
    which
  ];

  RAILS_ENV = "production";
  NODE_ENV = "production";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    fixup-yarn-lock yarn.lock

    substituteInPlace yarn.lock \
      --replace ', "@hotwired/turbo@https://github.com/docusealco/turbo#main"' ""

    yarn config --offline set yarn-offline-mirror $offlineCache

    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs node_modules

    # no idea how to patch this. instead we execute the two commands manually
    # ./bin/shakapacker
    bundle exec rails assets:precompile
    bundle exec rails shakapacker:compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r public/packs $out

    runHook postInstall
  '';
}
