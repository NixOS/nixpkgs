{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fetchYarnDeps,
  yarn,
  nodejs,
  prefetch-yarn-deps,
  fixup-yarn-lock,
  nodePackages,
  makeWrapper,
  gitUpdater,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "grist-core";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "gristlabs";
    repo = "grist-core";
    rev = "v${version}";
    hash = "sha256-8/voGPKKlhTBAjBRLatg5Sf98hTSnKdice+Fhy73wTA=";
  };

  patches = [
    # Upstream PR: https://github.com/gristlabs/grist-core/pull/1402
    ./remove-chokidar.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-alXkfkI1j2rjqI8BJQaBTMJTVPFbCL73+FvKfegFdXA=";
  };

  nativeBuildInputs = with nodePackages; [
    yarn
    nodejs
    prefetch-yarn-deps
    fixup-yarn-lock
    node-gyp-build
    node-pre-gyp
    makeWrapper
  ];

  propagatedBuildInputs = with python3.pkgs; [
    astroid
    asttokens
    chardet
    et-xmlfile
    executing
    friendly-traceback
    iso8601
    lazy-object-proxy
    openpyxl
    phonenumbers
    pure-eval
    python-dateutil
    roman
    six
    sortedcontainers
    stack-data
    typing-extensions
    unittest-xml-reporting
    wrapt
  ];

  passthru = {
    pythonEnv = python3.withPackages (_: propagatedBuildInputs);
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = { inherit (nixosTests) grist-core; };
  };

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)

    rm .yarnrc

    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup-yarn-lock yarn.lock

    mkdir -p "$HOME/.node-gyp/${nodejs.version}"
    echo 9 >"$HOME/.node-gyp/${nodejs.version}/installVersion"
    ln -sfv "${nodejs}/include" "$HOME/.node-gyp/${nodejs.version}"
    export npm_config_nodedir=${nodejs}

    yarn --offline --frozen-lockfile --ignore-platform --ignore-engines --no-progress --non-interactive install
    patchShebangs node_modules
    patchShebangs buildtools

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run build:prod

    # The node_modules folder is required by grist-core, but with dev dependencies it's 720MiB. Rebuilding the node_modules
    # folder without dev dependencies brings that down to 333MiB.
    yarn --offline --frozen-lockfile --ignore-platform --prod --ignore-engines --no-progress --non-interactive install

    patchShebangs node_modules

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/libexec" "$out/bin"

    cp -r {_build,node_modules,plugins,sandbox,static,bower_components} "$out/libexec"

    makeWrapper ${lib.getExe nodejs} $out/bin/grist-core \
      --add-flags "$out/libexec/_build/stubs/app/server/server.js" \
      --set "NODE_PATH" "$out/libexec/_build:$out/libexec/_build/stubs:$out/libexec/_build/ext"

    runHook postInstall
  '';

  meta = {
    description = "Grist is the evolution of spreadsheets";
    homepage = "https://github.com/gristlabs/grist-core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ scandiravian ];
    mainProgram = "grist-core";
    platforms = lib.platforms.all;
  };
}
