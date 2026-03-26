{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "kubectx";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "kubectx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rbfdqksNqWv2evrCl+2jMft2wBo7iWJoLvCABl1MUgk=";
  };

  vendorHash = "sha256-6bzTLnT69IdLwgbz/zZhjQYm8WpimJlItutW6fvwACs=";

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
    maintainers = with lib.maintainers; [
      jlesquembre
      miniharinn
    ];
  };
})
