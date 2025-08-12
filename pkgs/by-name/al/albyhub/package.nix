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
  version = "1.18.5";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j918jzhQs3dnPQaG4UMmoit8UvC8/3Z5+IiAZqO3OSA=";
  };

  vendorHash = "sha256-iMxxJQZLQOLl7v1SimtXSYH7wXFOdZcSJAaUAKDqvBY=";
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
    hash = "sha256-ttLhICDAsg8Cvqy2AJKgS2IJZgay1tMi3Qd8RccD1jI=";
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
