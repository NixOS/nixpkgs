{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  stdenv,
  makeWrapper,
  runCommand,
  callPackage,
}:

let
  barkFfiGo = callPackage ./bark-ffi-go { };
  ldkNode = callPackage ./ldk-node { };
  ldkNodeGo = callPackage ./ldk-node-go {
    inherit ldkNode;
  };

in

buildGoModule (finalAttrs: {
  pname = "albyhub";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1mdpsctrQN012+HAWSgorzlN2UBA5D4+sZIIVYCq8k8=";
  };

  vendorHash = "sha256-xQkQIWBrbrXzU9/5BMD3/+KKR847gh4XQrwj/CDoml0=";
  proxyVendor = true; # needed for secp256k1-zkp CGO bindings

  postPatch = ''
    cp -r ${barkFfiGo.src}/golang bark-ffi-bindings-golang
    chmod -R u+w bark-ffi-bindings-golang
    rm -r bark-ffi-bindings-golang/lib
    go mod edit -replace gitlab.com/ark-bitcoin/bark-ffi-bindings/golang=./bark-ffi-bindings-golang
  '';

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
    makeWrapper
  ];

  buildInputs = [
    barkFfiGo
    ldkNodeGo
    (lib.getLib stdenv.cc.cc)
  ];

  frontendYarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/frontend/yarn.lock";
    hash = "sha256-VI4FRe1kzVMqqcZ68nZmZqmXW7FOQMbJ0z8QqZoLYEA=";
  };

  preBuild = ''
    mkdir -p bark-ffi-bindings-golang/lib/linux_${stdenv.hostPlatform.go.GOARCH}
    cp ${barkFfiGo}/lib/libbark_ffi_go.a \
      bark-ffi-bindings-golang/lib/linux_${stdenv.hostPlatform.go.GOARCH}/libbark_ffi_go.a

    export HOME=$TMPDIR
    pushd frontend
      fixup-yarn-lock yarn.lock
      yarn config set yarn-offline-mirror "${finalAttrs.frontendYarnOfflineCache}"
      yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules
      yarn --offline build:http
    popd
  '';

  subPackages = [
    "cmd/http"
  ];

  ldflags = [
    "-X github.com/getAlby/hub/version.Tag=v${finalAttrs.version}"
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/http $out/bin/albyhub
  '';

  preFixup = ''
    patchelf --set-rpath ${
      lib.makeLibraryPath [
        ldkNode
        ldkNodeGo
        (lib.getLib stdenv.cc.cc)
      ]
    } $out/bin/albyhub
  '';

  passthru.tests.startup = runCommand "${finalAttrs.pname}-startup-test" { } ''
    export HOME="$TMPDIR"
    export AUTO_LINK_ALBY_ACCOUNT=false
    export WORK_DIR="$TMPDIR/albyhub"
    export DATABASE_URI="$WORK_DIR/nwc.db"
    export PORT=8099
    export LDK_LOG_LEVEL=2
    export LOG_LEVEL=5

    mkdir -p "$WORK_DIR"

    ${lib.getExe finalAttrs.finalPackage} > "$TMPDIR/albyhub.log" 2>&1 &
    pid=$!
    trap 'kill "$pid" 2>/dev/null || true' EXIT

    for _ in $(seq 1 30); do
      if grep -q "http server started" "$TMPDIR/albyhub.log"; then
        touch "$out"
        exit 0
      fi

      if ! kill -0 "$pid" 2>/dev/null; then
        echo "albyhub exited before startup" >&2
        cat "$TMPDIR/albyhub.log" >&2
        exit 1
      fi

      sleep 1
    done

    echo "timed out waiting for albyhub to start" >&2
    cat "$TMPDIR/albyhub.log" >&2
    exit 1
  '';

  meta = {
    description = "Control lightning wallets over nostr";
    homepage = "https://github.com/getAlby/hub";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bleetube ];
    mainProgram = "albyhub";
  };
})
# nixpkgs-update: no auto update
