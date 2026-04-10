{
  lib,
  stdenv,
  buildGoModule,
  faketty,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  go,
  makeWrapper,
  nodejs_20,
  nix-update-script,
  patchelf,
  removeReferencesTo,
  testers,
  yarn,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdktn-cli";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "open-constructs";
    repo = "cdk-terrain";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KgDRQ76ePLJEdULMCTJTouMaWu0SCeV4NwNW2WpoaNY=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-0aOwRdfCTiQHmWzOk+ExLX+/EAryxheyILe7L7oyd4w=";
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

  strictDeps = true;
  disallowedReferences = [ go ];

  nativeBuildInputs = [
    faketty
    fixup-yarn-lock
    go
    makeWrapper
    nodejs_20
    patchelf
    removeReferencesTo
    yarn
  ];

  postPatch = ''
    # wasm_exec has moved to lib in newer versions of Go
    substituteInPlace packages/@cdktn/hcl-tools/prebuild.sh \
      --replace-fail "misc/wasm/wasm_exec.js" "lib/wasm/wasm_exec.js"
    substituteInPlace packages/@cdktn/hcl2json/prebuild.sh \
      --replace-fail "misc/wasm/wasm_exec.js" "lib/wasm/wasm_exec.js"
  '';

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go
    export GOPROXY=file://${finalAttrs.hcltools-go-modules},file://${finalAttrs.hcl2json-go-modules}
    export GOSUMDB=off

    # Stop the build from trying to write checkpoints to /var/empty/
    export CHECKPOINT_DISABLE=1
  '';

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules packages

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bash ./tools/align-version.sh

    faketty yarn --offline build

    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    # Skip tests that require terraform (unfree)
    yarn --offline workspace cdktn-cli test -- \
      --testPathIgnorePatterns \
       "src/test/cmds/(convert|init).test.ts"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/cdktn-cli"
    cp -rL node_modules packages/cdktn-cli/bundle packages/cdktn-cli/package.json "$out/lib/node_modules/cdktn-cli/"

    makeWrapper "${lib.getExe nodejs_20}" "$out/bin/cdktn" \
      --add-flags "$out/lib/node_modules/cdktn-cli/bundle/bin/cdktn.js"

    runHook postInstall
  '';

  postInstall = ''
    # Go isn't needed at runtime, so remove these to decrease the closure size
    remove-references-to -t ${go} \
      "$out/lib/node_modules/cdktn-cli/node_modules/@cdktn/hcl-tools/main.wasm" \
      "$out/lib/node_modules/cdktn-cli/node_modules/@cdktn/hcl2json/main.wasm"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  # Tries to write to /var/empty/.terraform.d on darwin
  # even with writableTmpDirAsHomeHook and CHECKPOINT_DISABLE=1
  doInstallCheck = stdenv.hostPlatform.isLinux;

  passthru.updateScript = nix-update-script { };

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
