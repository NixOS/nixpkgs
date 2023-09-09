{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, karmor
}:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.15";

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
    hash = "sha256-irpfZFswZjowKDnHmoutTo6960jl5C3Dq+NurjOk3p8=";
  };

  vendorHash = "sha256-raMR27DqgT/Hjp3yAMAKLbfOjIZs0K0XsncgmIP6vxk=";

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
