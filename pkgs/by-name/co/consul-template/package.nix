{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "consul-template";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${finalAttrs.version}";
    hash = "sha256-54+MHi6ZmcDcHk1Swwt+25ZQOLPRytgZ8oDdlXsGVKo=";
  };

  vendorHash = "sha256-TffXWuVQKzaxwXozpdPJhwnBi9fmtolTZDPBsbVrOLY=";

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
})
