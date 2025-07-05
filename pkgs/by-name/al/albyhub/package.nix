{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  pkgs,
  yarn,
  stdenv,
  makeWrapper,
  callPackage,
  go,
}:

let
  ldkNode = callPackage ./ldk-node { };
  ldkNodeGo = callPackage ./ldk-node-go {
    inherit ldkNode;
  };

in

buildGoModule (finalAttrs: {
  pname = "albyhub";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7+5VWLO4J+ArHyTxapqVQL5GPofV4/QXCu5g+Ix9HoI=";
  };

  vendorHash = "sha256-uk0SzrzgT9BpFGMv5qUwXonXLvVgfjjudy+rlj3j5Yo=";
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
    hash = "sha256-SStTJGqeqPvXBKjFMPjKEts+jg6A9Vaqi+rZkr/ytdc=";
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
