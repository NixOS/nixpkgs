{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  faketty,
  nodejs-slim_22,
  versionCheckHook,
  makeBinaryWrapper,
  nix-update-script,
}:
let
  pnpm = pnpm_10;

  nodejs-slim = nodejs-slim_22;
  pnpm' = pnpm.override { inherit nodejs-slim; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "shopify";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "shopify";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-nxAyta3ADDa1D+W8iGk8bY6vpWOmst4Qa6qINaUFXnc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-8diskHx0Vv5RZhyCu3+Ao1FnVXH4COE8rvJu2ZttA8Y=";
  };

  nativeBuildInputs = [
    faketty
    nodejs-slim
    pnpmConfigHook
    pnpm'
    makeBinaryWrapper
  ];

  # workaround for https://github.com/nrwl/nx/issues/22445
  buildPhase = ''
    runHook preBuild

    faketty pnpm run bundle-for-release --disableRemoteCache=true --nxBail=true --outputStyle=static

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/@shopify/cli/{dist,bin}
    mkdir -p $out/bin
    pushd packages/cli
    rm -rf dist/*.map
    mv dist/* $out/lib/node_modules/@shopify/cli/dist
    mv bin/run.js $out/lib/node_modules/@shopify/cli/bin/run.js
    mv package.json oclif.manifest.json $out/lib/node_modules/@shopify/cli
    popd
    # Install runtime dependencies
    rm -rf node_modules
    pnpm config set nodeLinker hoisted
    # Avoid pnpm trying to replace directories with files (ENOTDIR) by
    # preferring non-symlinked executables and removing --force which can
    # exacerbate move/rename races during install.
    pnpm config set preferSymlinkedExecutables false
    pnpm install --offline --prod --ignore-scripts --frozen-lockfile
    mv node_modules $out/lib/node_modules/@shopify/cli/node_modules

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/shopify \
      --add-flags "$out/lib/node_modules/@shopify/cli/bin/run.js"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = lib.platforms.unix;
    mainProgram = "shopify";
    description = "CLI which helps you build against the Shopify platform faster";
    homepage = "https://github.com/Shopify/cli";
    changelog = "https://github.com/Shopify/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fd
      onny
    ];
  };
})
