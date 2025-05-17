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
}:

let
  ldkNode = callPackage ./ldk-node { };
  ldkNodeGo = callPackage ./ldk-node-go {
    inherit ldkNode;
  };

  # These are set to removed in 1.16 https://github.com/getAlby/hub/issues/667
  glalbyGo = callPackage ./glalby-go { };
  breezSdkGo = callPackage ./breez-sdk-go { };
in

buildGoModule rec {
  pname = "albyhub";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "hub";
    rev = "v${version}";
    hash = "sha256-fvmN2moxXIcd1meQq/zSGKOVEV07arM0Ct8hjOa1mD4=";
  };

  vendorHash = "sha256-Kc8R4SIb+XiWS01sHvISzL0b5tM2t0cJgae1ZnoNsIo=";

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
    makeWrapper
  ];

  buildInputs = [
    ldkNodeGo
    glalbyGo
    breezSdkGo
    (lib.getLib stdenv.cc.cc)
  ];

  frontendYarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/frontend/yarn.lock";
    hash = "sha256-QFhIpJkd426c3GaDSpI36CxlNGVKQoSN8wDgAVh9Ee4=";
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
    patchelf --set-rpath "${
      lib.makeLibraryPath [
        glalbyGo
        breezSdkGo
      ]
    }" $out/bin/albyhub
  '';

  postFixup = ''
    wrapProgram $out/bin/albyhub --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        glalbyGo
        breezSdkGo
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
