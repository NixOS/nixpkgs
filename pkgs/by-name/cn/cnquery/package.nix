{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "12.16.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    tag = "v${version}";
    hash = "sha256-dArqHTlygqlSl3+yPoG94InGfIJsw26yh2VWoaibI58=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-AldUs9cWsNZ5zgeBwe40b1f4NlOReY54V6O+0gkbY7Y=";

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
