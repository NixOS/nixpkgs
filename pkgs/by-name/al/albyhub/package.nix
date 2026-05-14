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
  callPackage,
}:

let
  ldkNode = callPackage ./ldk-node { };
  ldkNodeGo = callPackage ./ldk-node-go {
    inherit ldkNode;
  };

in

buildGoModule (finalAttrs: {
  pname = "albyhub";
  version = "1.21.6";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjFEou+mDtEf7079en5ypoU5P0tf+looeHZS4j1jKzg=";
  };

  vendorHash = "sha256-NJeIEFc8oc5rMWAuvrgsnOi3j779mhwMKSALswRy+nE=";
  proxyVendor = true; # needed for secp256k1-zkp CGO bindings

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
    makeWrapper
  ];

  buildInputs = [
    ldkNodeGo
    (lib.getLib stdenv.cc.cc)
  ];

  frontendYarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/frontend/yarn.lock";
    hash = "sha256-wdKm8Zk2iAPvH+EbQxvznctkqHgx8xl/Im37vHmHnoA=";
  };

  preBuild = ''
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
