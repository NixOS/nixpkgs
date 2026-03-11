{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cnspec";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qA48TBt1S4M6xyvfBELxbJd0R7PwY34naZctb4XRnwo=";
  };

  proxyVendor = true;

  vendorHash = "sha256-CwR0/L+ptBKjBLLZ7I96+jxJyCAgM7V0etXz+H0vlhI=";

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      fab
      mariuskimmina
    ];
  };
})
