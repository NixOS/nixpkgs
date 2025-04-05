{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cnquery";
  version = "11.48.0";

  src = fetchFromGitHub {
    owner = "mondoohq";
    repo = "cnquery";
    tag = "v${version}";
    hash = "sha256-d+TWg4T4p0QbLoUco88GIgnHfRpyealSasEzYf1YlXk=";
  };

  subPackages = [ "apps/cnquery" ];

  vendorHash = "sha256-w8xc1lGJkDMwjyVKdUlGfhn7DXlJJnqbOUfFg1Z9qC8=";

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
