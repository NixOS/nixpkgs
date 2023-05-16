<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, karmor
}:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.16";
=======
{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "karmor";
  version = "0.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubearmor";
    repo = "kubearmor-client";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-MEP7OlmsPe5qpdFBEOzCsJqLdZ5t7bMwPE/JhP9bGTY=";
  };

  vendorHash = "sha256-5r5UqWRmqrLcpTeYpezGxIMj9JnPaohhd1i7VvaBVGM=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.BuildDate=1970-01-01"
    "-X=github.com/kubearmor/kubearmor-client/selfupdate.GitSummary=${version}"
  ];

=======
    hash = "sha256-HSMyGA4S8VjEA2u4TbmH+qS5ZCsWBg+aTNhAbt4S6yY=";
  };

  vendorHash = "sha256-Rxm96sgdZFKuyQzT76WJHvzEM0tG2rvqnl7+umoFIMY=";

  nativeBuildInputs = [ installShellFiles ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # integration tests require network access
  doCheck = false;

  postInstall = ''
    mv $out/bin/{kubearmor-client,karmor}
    installShellCompletion --cmd karmor \
      --bash <($out/bin/karmor completion bash) \
      --fish <($out/bin/karmor completion fish) \
      --zsh  <($out/bin/karmor completion zsh)
  '';

<<<<<<< HEAD
  passthru.tests = {
    version = testers.testVersion {
      package = karmor;
      command = "karmor version || true";
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A client tool to help manage KubeArmor";
    homepage = "https://kubearmor.io";
    changelog = "https://github.com/kubearmor/kubearmor-client/releases/v${version}";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ urandom kashw2 ];
=======
    maintainers = with maintainers; [ urandom ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
