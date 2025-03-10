{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  go,
  nodejs,
  pkgs,
  yarn,
  stdenv,
  makeWrapper,
  callPackage,
}:

let
  ldkNodeGo = callPackage ./ldk-node-go { };
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
    pkgs.gcc
    makeWrapper
  ];

  buildInputs = [
    ldkNodeGo
    glalbyGo
    breezSdkGo
    stdenv.cc.cc.lib
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
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/http
    mkdir -p $out/lib
  '';

  postFixup = ''
    wrapProgram $out/bin/http --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '';

  meta = {
    description = "Control lightning wallets over nostr";
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    homepage = "https://github.com/getAlby/hub";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bleetube ];
    mainProgram = "http";
  };
}
