{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "12.5.1";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    tag = "v${version}";
    hash = "sha256-f7P7m+RBrWxvdBMtPXZLNB4/Alr0ByiEhh9mIcVPfLk=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-i0atpv6vtbbpTKuh9aJU6oPILCqdshB0MVbgOn6fppw=";

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
