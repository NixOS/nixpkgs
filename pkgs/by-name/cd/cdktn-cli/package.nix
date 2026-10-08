{
  lib,
  stdenv,
  buildGoModule,
  faketty,
  fetchFromGitHub,
  fetchPnpmDeps,
  go,
  makeWrapper,
  nodejs,
  nix-update-script,
  patchelf,
  pnpm_10,
  pnpmConfigHook,
  removeReferencesTo,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdktn-cli";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "open-constructs";
    repo = "cdk-terrain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vUGGg31MkuXdyvZo83GIoLZeJlOKIFgg3KlYU2F8hY=";
  };

  pnpmWorkspaces = [ "cdktn-cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmInstallFlags
      pnpmWorkspaces
      ;
    fetcherVersion = 3;
    hash = "sha256-2DTexRQg/n454cKaYitFT3KAT8BR+153KxlYMaa1NXM=";
    pnpm = pnpm_10;
  };

  hcl2json-go-modules =
    (buildGoModule {
      pname = "cdktn-hcl2json-go-modules";
      inherit (finalAttrs) version src;
      modRoot = "packages/@cdktn/hcl2json";
      vendorHash = "sha256-OiKPq0CHkOxJaFzgsaNJ02tasvHtHWylmaPRPayJob4=";
      proxyVendor = true;
      doCheck = false;
      env.GOWORK = "off";
    }).goModules;

  hcltools-go-modules =
    (buildGoModule {
      pname = "cdktn-hcltools-go-modules";
      inherit (finalAttrs) version src;
      modRoot = "packages/@cdktn/hcl-tools";
      vendorHash = "sha256-orGxkYEQVtTKvXb7/FD/CLwqSINgBQFTF5arbR0xAvE=";
      proxyVendor = true;
      doCheck = false;
      env.GOWORK = "off";
    }).goModules;

  pnpmInstallFlags = [ "--shamefully-hoist" ];
  strictDeps = true;
  disallowedReferences = [ go ];

  nativeBuildInputs = [
    faketty
    go
    makeWrapper
    nodejs
    patchelf
    pnpm_10
    pnpmConfigHook
    removeReferencesTo
  ];

  postPatch = ''
    # Fix tests (workaround for https://github.com/open-constructs/cdk-terrain/issues/381)
    substituteInPlace jest.preset.js \
      --replace-fail "...nxPreset," "...nxPreset, transform: {},"

    patchShebangs packages
  '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${finalAttrs.hcltools-go-modules},file://${finalAttrs.hcl2json-go-modules}
    export GOSUMDB=off

    # Stop the build from trying to write checkpoints to /var/empty/
    export CHECKPOINT_DISABLE=1
  '';

  buildPhase = ''
    runHook preBuild

    node tools/align-version.mjs

    faketty pnpm --filter "cdktn-cli..." run build

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # Skip tests that require terraform (unfree)
    pnpm --filter cdktn-cli exec jest \
      --testPathIgnorePatterns \
       "src/test/cmds/convert.test.ts"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    pnpm install --force --offline --production --ignore-scripts --shamefully-hoist --filter "cdktn-cli..."

    mkdir -p "$out/lib/cdktn"
    cp -r node_modules packages package.json "$out/lib/cdktn/"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/cdktn" \
      --set-default CHECKPOINT_DISABLE 1 \
      --add-flags "--no-warnings=DEP0040" \
      --add-flags "$out/lib/cdktn/packages/cdktn-cli/bundle/bin/cdktn.js"

    runHook postInstall
  '';

  postInstall = ''
    # Go isn't needed at runtime, so remove these to decrease the closure size
    remove-references-to -t ${go} \
      "$out/lib/cdktn/packages/@cdktn/hcl-tools/main.wasm" \
      "$out/lib/cdktn/packages/@cdktn/hcl2json/main.wasm"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Tries to write to /var/empty/.terraform.d on darwin
  # even with writableTmpDirAsHomeHook and CHECKPOINT_DISABLE=1
  doInstallCheck = stdenv.hostPlatform.isLinux;

  passthru.updateScript = nix-update-script {
    # Skip pre-releases
    extraArgs = [
      "--version-regex"
      "^v([\\d.]+)$"
    ];
  };

  meta = {
    description = "CDK for Terraform CLI";
    homepage = "https://cdktn.io";
    changelog = "https://github.com/open-constructs/cdk-terrain/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    mainProgram = "cdktn";
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.unix;
  };
})
