{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  faketty,
  nodejs,
  versionCheckHook,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shopify";
  version = "3.88.1";

  src = fetchFromGitHub {
    owner = "shopify";
    repo = "cli";
    tag = finalAttrs.version;
    hash = "sha256-G4sk0V//JcJ+z3EdWsh+VDSJl102Ww9bgohdgxmUQ+0=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-l+Hw5n8AqdQimPQFkN92LVhH6zFlyJped6UD69lQ+vg=";
  };

  nativeBuildInputs = [
    faketty
    nodejs
    pnpm.configHook
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
    pnpm install --offline --prod --force --ignore-scripts --frozen-lockfile
    mv node_modules $out/lib/node_modules/@shopify/cli/node_modules

    makeWrapper ${lib.getExe nodejs} $out/bin/shopify \
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
    changelog = "https://github.com/Shopify/cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fd
      onny
    ];
  };
})
