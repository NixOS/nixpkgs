{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "consul-template";
  version = "0.41.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${version}";
    hash = "sha256-YZ6PZh9ZFEaanTkvQ6I35ubRxSKB/dMq8JXLPf5Ym4I=";
  };

  vendorHash = "sha256-IfOaJlcMNRWxC0XNZYU/5Lz3ILlMWSfzFXwLu3gLKOc=";

  # consul-template tests depend on vault and consul services running to
  # execute tests so we skip them here
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) consul-template;
  };

  meta = {
    homepage = "https://github.com/hashicorp/consul-template/";
    description = "Generic template rendering and notifications with Consul";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      cpcloud
    ];
    mainProgram = "consul-template";
  };
}
