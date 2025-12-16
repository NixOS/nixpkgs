{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "12.13.2";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${version}";
    hash = "sha256-i/vHKFvlHjTRPo2btOuc6vql7D5FSP7PvAsnIf7zEe0=";
  };

  proxyVendor = true;

  vendorHash = "sha256-JIG+KV+5na6QdfT4lxUEzvE6HejzxthBRtmYAnsV+ko=";

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

  meta = {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [
      fab
      mariuskimmina
    ];
  };
}
