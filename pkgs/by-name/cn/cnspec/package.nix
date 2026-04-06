{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cnspec";
  version = "13.3.3";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yCxry1f5CEF51WSgrYN1m9F8YpVjtt+UNZG978nPXbY=";
  };

  proxyVendor = true;

  vendorHash = "sha256-wgebRTa1ox+LUzxlYLb3pqcLEF/uUushZ1Oq2mvRGCk=";

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
