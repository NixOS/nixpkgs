{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  python3,
  jq,
  yarn,
  nodejs-slim,
}:

rustPlatform.buildRustPackage rec {
  pname = "fernglas";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "wobcom";
    repo = "fernglas";
    rev = "fernglas-${version}";
    hash = "sha256-0wj5AS8RLVr+S/QWWxCsMvmVjmXUWGfR9kPaZimJEss=";
  };

  nativeBuildInputs = [
    yarn
    nodejs-slim
    fixup-yarn-lock
    python3
    jq
  ];

  nlnog_communities = fetchFromGitHub {
    owner = "NLNOG";
    repo = "lg.ring.nlnog.net";
    rev = "20f9a9f3da8b1bc9d7046e88c62df4b41b4efb99";
    hash = "sha256-FlbOBX/+/LLmoqMJLvu59XuHYmiohIhDc1VjkZu4Wzo=";
  };

  cargoHash = "sha256-aY5/dIplV8yWaQ2IdWxxC7T1DoKeRjsN5eT+UxsaA1E=";

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/frontend/yarn.lock";
    hash = "sha256-/ubCAs4C5nG8xNC77jTH+cJVNgddSxqGGPEVLDH/Cdo=";
  };

  cargoBuildFlags =
    lib.optionals (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isStatic) [
      "--features"
      "mimalloc"
    ]
    ++ [
      "--features"
      "embed-static"
    ];

  preBuild = ''
    python3 contrib/print_communities.py $nlnog_communities/communities | jq . > src/communities.json

    pushd frontend

    export HOME=$TMPDIR
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    FERNGLAS_VERSION=${version} FERNGLAS_COMMIT=${src.rev} node_modules/.bin/webpack
    cp -r dist/ ../static

    popd
  '';

  meta = {
    description = "Looking glass for your network using BGP and BMP as data source";
    homepage = "https://wobcom.github.io/fernglas/";
    changelog = "https://github.com/wobcom/fernglas/releases/tag/fernglas-${version}";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.wdz ];
    mainProgram = "fernglas";
  };
}
