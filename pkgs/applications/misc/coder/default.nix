{ lib, pkgs, fetchFromGitHub, installShellFiles, buildGoModule, fetchYarnDeps }:

let
  pname = "coder";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "coder";
    repo = "coder";
    rev = "v${version}";
    sha256 = "sha256-h5bN75agNocRAjShbufRCJr45huYJOzCBd4OcGpF4C4=";
  };
  
  offlineCache = fetchYarnDeps {
    yarnLock = src + "/site/yarn.lock";
    sha256 = "sha256-uDNPRQTpsgxyC5ks+2Qq/wiKjkbjWwSO+cJc5X6qmAA=";
  };

  yarn16 = pkgs.yarn.override { nodejs = pkgs.nodejs-16_x; };
  nodePackages16 = pkgs.nodePackages.override { nodejs = pkgs.nodejs-16_x; };
in
buildGoModule rec {
  inherit pname version src;

  subPackages = [ "cmd/coder" ];

  vendorSha256 = "sha256-+3Zy0zArCXkvD4ogfKdu9W9gJXveAhwFXKG1VRDvOkI=";

  # Flags as provided by the build automation of the project:
  #   https://github.com/coder/coder/blob/075e891f287b27cdb481a48e129f20a1e6a7de12/scripts/build_go.sh#L89
  ldflags = [
    "-s"
    "-w"
    "-X github.com/coder/coder/buildinfo.tag=${version}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME

    cd site
    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup_yarn_lock yarn.lock

    # node-gyp tries to download always the headers and fails: https://github.com/NixOS/nixpkgs/issues/195404
    yarn remove --offline jest-canvas-mock canvas

    NODE_ENV=production node node_modules/.bin/vite build
    cd ..
  '';

  tags = [ "embed" ];

  nativeBuildInputs = with pkgs; [ 
    fixup_yarn_lock 
    nodejs-16_x
    yarn16 
    nodePackages16.node-pre-gyp 
    python3 
    pkg-config
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd coder \
      --bash <($out/bin/coder completion bash) \
      --zsh <($out/bin/coder completion zsh)
  '';

  meta = with lib; {
    description = "Software development on any infrastructure";
    license = licenses.agpl3Only;
    homepage = "https://coder.com/";
    maintainers = with maintainers; [ shyim ];
  };
}
