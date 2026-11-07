{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "garm-provider-incus";
  version = "0.1.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloudbase";
    repo = "garm-provider-incus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0xBNhuULfUYzy6mou80gr/kW6mooIe8h1OCkVO3RdmI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-X github.com/cloudbase/garm-provider-incus/provider.Version=v${finalAttrs.version}"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) garm-incus;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Incus external provider for GARM";
    homepage = "https://github.com/cloudbase/garm-provider-incus";
    changelog = "https://github.com/cloudbase/garm-provider-incus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "garm-provider-incus";
  };
})
