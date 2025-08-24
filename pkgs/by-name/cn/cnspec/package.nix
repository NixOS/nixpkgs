{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnspec";
  version = "11.68.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnspec";
    tag = "v${version}";
    hash = "sha256-OFV6xk8JbdmW0hj6UsrK/KW96kVNSCtzQ75dGLeuJCk=";
  };

  proxyVendor = true;

  vendorHash = "sha256-vVCpA7ete2XPcwSZLmtcmdcc467g+KI5zXbZVjZsur4=";

  subPackages = [ "apps/cnspec" ];

  ldflags = [
    "-s"
    "-w"
    "-X=go.mondoo.com/cnspec.Version=${version}"
  ];

  meta = with lib; {
    description = "Open source, cloud-native security and policy project";
    homepage = "https://github.com/mondoohq/cnspec";
    changelog = "https://github.com/mondoohq/cnspec/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      fab
      mariuskimmina
    ];
  };
}
