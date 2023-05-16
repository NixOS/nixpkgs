{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, kubeone
, testers
}:

buildGoModule rec {
  pname = "kubeone";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubermatic";
    repo = "kubeone";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-izUjiRQAdTpdk86s1lQwLfpHy4eJo3mGAgTwWfGkNAQ=";
  };

  vendorHash = "sha256-AFyvTv1uVeq2KtRG6VToTBnX+8tHorDZPSturJhsrG4=";
=======
    hash = "sha256-dLpe3C1gMnEyajJFPawDlTchYKA8cAy2QUAae6+7QBQ=";
  };

  vendorHash = "sha256-aCRrf/E4UVL6PwUPRRzLjD+MzL8gcNJrc2IgKKyIIHI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
    "-X k8c.io/kubeone/pkg/cmd.version=${version}"
    "-X k8c.io/kubeone/pkg/cmd.date=unknown"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd kubeone \
      --bash <($out/bin/kubeone completion bash) \
      --zsh <($out/bin/kubeone completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kubeone;
    command = "kubeone version";
  };

  meta = with lib; {
    description = "Automate cluster operations on all your cloud, on-prem, edge, and IoT environments";
    homepage = "https://kubeone.io/";
    changelog = "https://github.com/kubermatic/kubeone/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lblasc ];
  };
}
