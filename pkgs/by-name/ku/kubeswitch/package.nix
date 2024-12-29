{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  kubeswitch,
  installShellFiles,
}:

buildGoModule rec {
  pname = "kubeswitch";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "danielfoehrKn";
    repo = "kubeswitch";
    rev = version;
    hash = "sha256-P6pMT3TzY5CKFEQZMiwVeOuOCx6/SUpacKAcgjCeE5w=";
  };

  vendorHash = null;

  subPackages = [ "cmd/main.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/danielfoehrkn/kubeswitch/cmd/switcher.version=${version}"
    "-X github.com/danielfoehrkn/kubeswitch/cmd/switcher.buildDate=1970-01-01"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mv $out/bin/main $out/bin/switcher
    for shell in bash zsh fish; do
      $out/bin/switcher --cmd switcher completion $shell > switcher.$shell
      installShellCompletion --$shell switcher.$shell
    done
  '';

  passthru.tests.version = testers.testVersion { package = kubeswitch; };

  meta = {
    changelog = "https://github.com/danielfoehrKn/kubeswitch/releases/tag/${version}";
    description = "Kubectx for operators, a drop-in replacement for kubectx";
    license = lib.licenses.asl20;
    homepage = "https://github.com/danielfoehrKn/kubeswitch";
    maintainers = with lib.maintainers; [ bryanasdev000 ];
    mainProgram = "switcher";
  };
}
