{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, testers
, kubedog
}:

buildGoModule rec {
  pname = "kubedog";
<<<<<<< HEAD
  version = "0.9.12";
=======
  version = "0.9.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "werf";
    repo = "kubedog";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-B667EnlOD0kXqkW73XXcyQwROWh5SmsM8565sjcGinI=";
=======
    hash = "sha256-yHyCmUjxvMzeHpG5OqC3nAjWaiHErTXrbmS+/0Y4A7E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-OgfgCsysNtY7mZQXdmHFyJ0FqmBD3SeQdTLd5Lw3F7k=";

  subPackages = [ "cmd/kubedog" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/werf/kubedog.Version=${src.rev}"
  ];

  # There are no tests.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = kubedog;
    command = "kubedog version";
    version = src.rev;
  };

  meta = with lib; {
    description = ''
      A tool to watch and follow Kubernetes resources in CI/CD deployment
      pipelines
    '';
    homepage = "https://github.com/werf/kubedog";
    changelog = "https://github.com/werf/kubedog/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi ];
  };
}
