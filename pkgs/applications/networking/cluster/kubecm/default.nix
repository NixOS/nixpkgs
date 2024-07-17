{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kubecm";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "sunny0826";
    repo = "kubecm";
    rev = "v${version}";
    hash = "sha256-zyXxMp+59buSwm4fZY62b2xqAmq7XAzhET0qez8oWPs=";
  };

  vendorHash = "sha256-6RrnsRbQ1+Cx7vnqauisBICgwmvTpJQT32DnIDVc6ts=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/sunny0826/kubecm/version.Version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Manage your kubeconfig more easily";
    homepage = "https://github.com/sunny0826/kubecm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
    mainProgram = "kubecm";
  };
}
