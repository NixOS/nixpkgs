{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "consul-template";
  version = "0.42.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "consul-template";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J/dUlF7FBo+WLMA6ff0WlqD1oqsmPI2W8ebW1eNTUX4=";
  };

  vendorHash = "sha256-wmbv/YrjRweTsaA/3mXKx2L8yNdoSRXRVyEcaraJ/nw=";

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
