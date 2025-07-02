{
  stdenv,
  lib,
  nixosTests,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  python3,
  node-gyp,
  cctools,
  xcbuild,
  libkrb5,
  libmongocrypt,
  libpq,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n8n";
  version = "1.100.1";

  src = fetchFromGitHub {
    owner = "n8n-io";
    repo = "n8n";
    tag = "n8n@${finalAttrs.version}";
    hash = "sha256-S5GGJRLTpr1HfXnXRXO6hcVjgjRWvbknABEsGkTq428=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-HzJej2Mt110n+1KX0wzuAn6j69zQOzI42EGxQB6PYbc=";
  };

  nativeBuildInputs =
    [
      pnpm_10.configHook
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

    pnpm --ignore-scripts prune --prod
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
    mv {packages,node_modules} $out/lib/n8n

    makeWrapper $out/lib/n8n/packages/cli/bin/n8n $out/bin/n8n \
      --set N8N_RELEASE_TYPE "stable"

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
    ];
    license = lib.licenses.sustainableUse;
    mainProgram = "n8n";
    platforms = lib.platforms.unix;
  };
})
