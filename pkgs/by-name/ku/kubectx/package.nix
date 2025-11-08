{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectx";
    rev = "v${version}";
    hash = "sha256-HVmtUhdMjbkyMpTgbsr5Mm286F9Q7zbc5rOxi7OBZEg=";
  };

  vendorHash = "sha256-3xetjviMuH+Nev12DB2WN2Wnmw1biIDAckUSGVRHQwM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = with lib; {
    description = "Fast way to switch between clusters and namespaces in kubectl";
    license = licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with maintainers; [ jlesquembre ];
  };
}
