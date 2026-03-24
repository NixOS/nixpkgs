{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubectx";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LgZz/fRpIf/D3WmRic/P8O+wOrgKbDyAyBWzdOxXjKQ=";
  };

  vendorHash = "sha256-BbGXJM1RMn7dgd8aaaGxRkqgs398rwpONWUcCcWNZow=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = {
    description = "Fast way to switch between clusters and namespaces in kubectl";
    license = lib.licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
