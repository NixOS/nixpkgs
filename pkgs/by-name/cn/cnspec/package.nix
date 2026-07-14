{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cnspec";
  version = "13.28.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9AlHvxWdmJIdfvmok9n+6g0k5A4Rts2+G5pO9xbYWSQ=";
  };

  proxyVendor = true;

  vendorHash = "sha256-LTzg76RQOV0d3Xk4Q8NvBnmTQv4QhJutNoJPw0gCCII=";

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
