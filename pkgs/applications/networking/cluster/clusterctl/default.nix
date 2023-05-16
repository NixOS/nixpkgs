{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, clusterctl }:

buildGoModule rec {
  pname = "clusterctl";
<<<<<<< HEAD
  version = "1.5.1";
=======
  version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "cluster-api";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yzk2zIk3igi7xlOi8RlGsthxy/M051SsiLi2v0gMWYk=";
  };

  vendorHash = "sha256-FUimSBMZI4BDtNKnlzmxe2HiL7MGIUh7SFC2dwWYT3I=";
=======
    hash = "sha256-NvCQs6YzQ2zNLQiYgFK/q2c74g/+YkzQIQJWEINOYIE=";
  };

  vendorHash = "sha256-ZJFpzBeC048RZ6YfjXQPyohCO1WagxXvBBacifkfkjE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/clusterctl" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = let t = "sigs.k8s.io/cluster-api/version"; in [
    "-X ${t}.gitMajor=${lib.versions.major version}"
    "-X ${t}.gitMinor=${lib.versions.minor version}"
    "-X ${t}.gitVersion=v${version}"
  ];

  postInstall = ''
    # errors attempting to write config to read-only $HOME
    export HOME=$TMPDIR

    installShellCompletion --cmd clusterctl \
      --bash <($out/bin/clusterctl completion bash) \
      --zsh <($out/bin/clusterctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = clusterctl;
    command = "HOME=$TMPDIR clusterctl version";
    version = "v${version}";
  };

  meta = with lib; {
    changelog = "https://github.com/kubernetes-sigs/cluster-api/releases/tag/${src.rev}";
    description = "Kubernetes cluster API tool";
    homepage = "https://cluster-api.sigs.k8s.io/";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ qjoly ];
=======
    maintainers = with maintainers; [ zowoq ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
