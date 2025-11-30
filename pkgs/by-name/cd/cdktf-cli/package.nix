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
  nodejs,
  nix-update-script,
  patchelf,
  removeReferencesTo,
  testers,
  yarn,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cdktf-cli";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-cdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iqy8j1bqwjSRBOj8kjFtAq9dLiv6dDbJsiFGQUhGW7k=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-qGjzy/+u8Ui9aHK0sX3MfYbkj5Cqab4RlhOgrwbEmGs=";
  };

  hcl2json-go-modules =
    (buildGoModule {
      pname = "cdktf-hcl2json-go-modules";
      inherit (finalAttrs) version src;
      modRoot = "packages/@cdktf/hcl2json";
      vendorHash = "sha256-OiKPq0CHkOxJaFzgsaNJ02tasvHtHWylmaPRPayJob4=";
      proxyVendor = true;
      doCheck = false;
      env.GOWORK = "off";
    }).goModules;

  hcltools-go-modules =
    (buildGoModule {
      pname = "cdktf-hcltools-go-modules";
      inherit (finalAttrs) version src;
      modRoot = "packages/@cdktf/hcl-tools";
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
    nodejs
    patchelf
    removeReferencesTo
    yarn
  ];

  postPatch = ''
    # wasm_exec has moved to lib in newer versions of Go
    substituteInPlace packages/@cdktf/hcl-tools/prebuild.sh \
      --replace-fail "misc/wasm/wasm_exec.js" "lib/wasm/wasm_exec.js"
    substituteInPlace packages/@cdktf/hcl2json/prebuild.sh \
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
    yarn --offline workspace cdktf-cli test -- \
      --testPathIgnorePatterns \
       "src/test/cmds/(convert|init).test.ts"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/cdktf-cli"
    cp -rL node_modules packages/cdktf-cli/bundle packages/cdktf-cli/package.json "$out/lib/node_modules/cdktf-cli/"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/cdktf" \
      --add-flags "$out/lib/node_modules/cdktf-cli/bundle/bin/cdktf.js"

    runHook postInstall
  '';

  postInstall = ''
    # Go isn't needed at runtime, so remove these to decrease the closure size
    remove-references-to -t ${go} \
      "$out/lib/node_modules/cdktf-cli/node_modules/@cdktf/hcl-tools/main.wasm" \
      "$out/lib/node_modules/cdktf-cli/node_modules/@cdktf/hcl2json/main.wasm"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CDK for Terraform CLI";
    homepage = "https://github.com/hashicorp/terraform-cdk";
    changelog = "https://github.com/hashicorp/terraform-cdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    mainProgram = "cdktf";
    maintainers = with lib.maintainers; [ deejayem ];
    platforms = lib.platforms.unix;
  };
})
