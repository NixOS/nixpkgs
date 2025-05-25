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

buildGoModule rec {
  pname = "albyhub";
  version = "v1.17.1";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    rev = "v1.17.1";
    hash = "sha256-ZDTCA3nMJEA8I7PeSgwQAe+wU8Wk0GaH3ItQLzPhOBQ=";
  };

  vendorHash = lib.fakeHash;

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
    yarnLock = src + "/frontend/yarn.lock";
    hash = lib.fakeHash;
  };

  preBuild = ''
    export HOME=$TMPDIR

    pushd frontend
      fixup-yarn-lock yarn.lock
      yarn config set yarn-offline-mirror "${frontendYarnOfflineCache}"
      yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules
      yarn --offline build:http
    popd
  '';

  subPackages = [
    "cmd/http"
  ];

  ldflags = [
    "-X github.com/getAlby/hub/version.Tag=v${version}"
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/http $out/bin/albyhub
  '';

  postFixup = ''
    wrapProgram $out/bin/albyhub --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        ldkNode
        ldkNodeGo
        (lib.getLib stdenv.cc.cc)
      ]
    }
  '';

  meta = {
    description = "Control lightning wallets over nostr";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    homepage = "https://github.com/getAlby/hub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bleetube ];
    mainProgram = "albyhub";
  };
}
