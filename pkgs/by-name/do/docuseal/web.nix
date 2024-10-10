{
  stdenv,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  which,
  version,
  src,
  meta,
  rubyEnv,
}:
stdenv.mkDerivation {
  pname = "docuseal-web";
  inherit version src meta;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-gYmfXj9FZYJj6MbL8i3kZMaVothKFZIbHHeU+e8lBHY=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
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

    yarn config --offline set yarn-offline-mirror $offlineCache

    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs node_modules

    # no idea how to patch this. instead we execute the two commands manually
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
