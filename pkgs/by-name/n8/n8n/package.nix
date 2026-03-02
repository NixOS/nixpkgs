{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  python3,
  node-gyp,
  cctools,
  xcbuild,
  libkrb5,
  libmongocrypt,
  libpq,
  makeWrapper,
}:
let
  python = python3.withPackages (
    ps: with ps; [
      websockets
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "n8n";
  version = "2.9.4";

  src = fetchFromGitHub {
    owner = "n8n-io";
    repo = "n8n";
    tag = "n8n@${finalAttrs.version}";
    hash = "sha256-XXQPZHtY66gOQ+nYH+Q1IjbR+SRZ9g06sgBy2x8gGh4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-TU7HIShYj20QtdcthP0nQdubYl0bdy+XM3CoX5Rvhzk=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    python3 # required to build sqlite3 bindings
    node-gyp # required to build sqlite3 bindings
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    cctools
    xcbuild
  ];

  buildInputs = [
    nodejs
    libkrb5
    libmongocrypt
    libpq
  ];

  buildPhase = ''
    runHook preBuild

    pushd node_modules/sqlite3
    node-gyp rebuild
    popd

    # TODO: use deploy after resolved https://github.com/pnpm/pnpm/issues/5315
    pnpm build --filter=n8n

    runHook postBuild
  '';

  preInstall = ''
    echo "Removing non-deterministic and unnecessary files"

    find -type d -name .turbo -exec rm -rf {} +
    rm node_modules/.modules.yaml
    rm packages/nodes-base/dist/types/nodes.json

    CI=true pnpm --ignore-scripts prune --prod
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    rm -rf node_modules/.pnpm/{typescript*,prettier*}
    shopt -s globstar
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules packages/**/node_modules -xtype l -delete

    echo "Removed non-deterministic and unnecessary files"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/n8n}
    cp -r {packages,node_modules} $out/lib/n8n

    makeWrapper $out/lib/n8n/packages/cli/bin/n8n $out/bin/n8n \
      --set N8N_RELEASE_TYPE "stable"

    # JavaScript runner
    makeWrapper ${nodejs}/bin/node $out/bin/n8n-task-runner \
      --add-flags "$out/lib/n8n/packages/@n8n/task-runner/dist/start.js"

    # Python runner
    mkdir -p $out/lib/n8n-task-runner-python
    cp -r packages/@n8n/task-runner-python/* $out/lib/n8n-task-runner-python/
    makeWrapper ${python}/bin/python $out/bin/n8n-task-runner-python \
      --add-flags "$out/lib/n8n-task-runner-python/src/main.py" \
      --prefix PYTHONPATH : "$out/lib/n8n-task-runner-python"

    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.n8n;
    updateScript = ./update.sh;
  };

  # this package has ~80000 files, these take too long and seem to be unnecessary
  dontStrip = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  meta = {
    description = "Free and source-available fair-code licensed workflow automation tool";
    longDescription = ''
      Free and source-available fair-code licensed workflow automation tool.
      Easily automate tasks across different services.
    '';
    homepage = "https://n8n.io";
    changelog = "https://github.com/n8n-io/n8n/releases/tag/n8n@${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      gepbird
      AdrienLemaire
      sweenu
    ];
    license = lib.licenses.sustainableUse;
    mainProgram = "n8n";
    platforms = lib.platforms.unix;
  };
})
