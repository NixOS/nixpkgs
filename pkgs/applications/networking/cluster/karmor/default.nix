{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, karmor
}:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.7";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
    hash = "sha256-IZUDVw41AfugqVG2hsxoKO7zl1FraVzME/GUxZwaAG4=";
  };

  vendorHash = "sha256-VT0CiaG5AODAL6nhoPmpulPApgTUiH0mXI6mS1eK14k=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=1970-01-01"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=${version}"
  ];

  # integration tests require network access
  doCheck = false;

  postInstall = ''
    mv $out/bin/{kubearmor-client,karmor}
    installShellCompletion --cmd karmor \
      --bash <($out/bin/karmor completion bash) \
      --fish <($out/bin/karmor completion fish) \
      --zsh  <($out/bin/karmor completion zsh)
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = karmor;
      command = "karmor version || true";
    };
  };

  meta = with lib; {
    description = "A client tool to help manage KubeArmor";
    homepage = "https://kubearmor.io";
    changelog = "https://github.com/kubearmor/kubearmor-client/releases/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ urandom ];
  };
}
