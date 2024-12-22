{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "11.35.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    rev = "refs/tags/v${version}";
    hash = "sha256-WBzl3DyjPr5vV9oobqZx1pprs4gkVN9BafOMIMqqb7E=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-rgjYpiTWp9KqC7gX05Fx5h2hKT1ah2GQorPzPhJpQH0=";

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
