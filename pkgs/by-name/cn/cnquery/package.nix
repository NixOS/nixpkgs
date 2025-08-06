{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "11.65.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    tag = "v${version}";
    hash = "sha256-M2bx4wgVM79iXhtZDFvcOfifwbLCTQ0knTI3FAOzj3M=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-b+E8thljWxRwbBca2TdTINQERnOvfQncSEJ0+Nxuk8M=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Cloud-native, graph-based asset inventory";
    longDescription = ''
      cnquery is a cloud-native tool for querying your entire fleet. It answers thousands of
      questions about your infrastructure and integrates with over 300 resources across cloud
      accounts, Kubernetes, containers, services, VMs, APIs, and more.
    '';
    homepage = "https://mondoo.com/cnquery";
    changelog = "https://github.com/mondoohq/cnquery/releases/tag/v${version}";
    license = lib.licenses.bsl11;
    maintainers = with lib.maintainers; [ mariuskimmina ];
  };
}
