{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  faketty,
  nodejs,
  nodejs_22,
  versionCheckHook,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    pnpmForBuild = pnpm.override { nodejs = nodejs_22; };
  in
  {
    pname = "shopify";
    version = "3.86.1";

    src = fetchFromGitHub {
      owner = "shopify";
      repo = "cli";
      tag = finalAttrs.version;
      hash = "sha256-wEddzW5/+qdtNTxdUs7YEA5vk6/KjrVOgWvIeo0o2ww=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-JhyZpkrp78FECH6UKYYuhWF2w/mYW1BQG5FIsWh5GRE=";
    };

    nativeBuildInputs = [
      faketty
      nodejs
      pnpmConfigHook
      pnpmForBuild
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
  }
)
