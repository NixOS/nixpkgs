{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, roxctl }:

buildGoModule rec {
  pname = "roxctl";
<<<<<<< HEAD
  version = "4.1.2";
=======
  version = "4.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-5wNf80kiYnKg/urIQQqe4HijqxQweiFx0UktFiOTeaU=";
  };

  vendorHash = "sha256-5glD904guK+TR9YFzeuIyHOXrJblcEVi9EReQz0fCCA=";
=======
    sha256 = "sha256-HDhR85plO3UDYPZ/uBiGfNXm1txKQoA4KbYMCvQ2pwY=";
  };

  vendorHash = "sha256-kv5kNFFw57ZuNgwNMucmCPIwaAhpzT0hs2K1B65WxpU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "roxctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stackrox/rox/pkg/version/internal.MainVersion=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd roxctl \
      --bash <($out/bin/roxctl completion bash) \
      --fish <($out/bin/roxctl completion fish) \
      --zsh <($out/bin/roxctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = roxctl;
    command = "roxctl version";
  };

  meta = with lib; {
    description = "Command-line client of the StackRox Kubernetes Security Platform";
    license = licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with maintainers; [ stehessel ];
  };
}
