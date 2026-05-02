{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "consul-template";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fQXkM2DnKELmchlIEW5O4jLiuJQ3LeCu/WkzMWCwwc8=";
  };

  vendorHash = "sha256-GOHEd3Ftlk2fnI6K14627izq6F5bIGFhDSgB62xw8OE=";

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
