{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "11.52.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    tag = "v${version}";
    hash = "sha256-Agc8as9PwN9IDeV0tBOPFL2tXYXYaJsa1sd+XXQ7p0k=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-gvRsEIYEj5D+P8gFlGdfHC/3Pho5YYZxKm6Mkq8lwQw=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Cloud-native, graph-based asset inventory";
    longDescription = ''
      cnquery is a cloud-native tool for querying your entire fleet. It answers thousands of
      questions about your infrastructure and integrates with over 300 resources across cloud
      accounts, Kubernetes, containers, services, VMs, APIs, and more.
    '';
    homepage = "https://mondoo.com/cnquery";
    changelog = "https://github.com/mondoohq/cnquery/releases/tag/v${version}";
    license = licenses.bsl11;
    maintainers = with maintainers; [ mariuskimmina ];
  };
}
