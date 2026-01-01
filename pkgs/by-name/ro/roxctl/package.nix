{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  roxctl,
}:

buildGoModule rec {
  pname = "roxctl";
<<<<<<< HEAD
  version = "4.9.2";
=======
  version = "4.9.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = "stackrox";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-A9uumIOtuRXMIy0K5BEUp4iICr1jVWiXxfSTESQYkIg=";
  };

  vendorHash = "sha256-AWR24cqv0h/lESMit4U4FnaxkBLl1fe/TlXeE8rI9EE=";
=======
    sha256 = "sha256-zlmXIqFXp2vnsTsY12zWwMjhPwt7ZM746EjQWVwgKe0=";
  };

  vendorHash = "sha256-IyeJS5RHcBkw2bvZklIojrQZBPRhJ+JAnggGm113Lns=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "roxctl" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stackrox/rox/pkg/version/internal.MainVersion=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd roxctl \
      --bash <($out/bin/roxctl completion bash) \
      --fish <($out/bin/roxctl completion fish) \
      --zsh <($out/bin/roxctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = roxctl;
    command = "roxctl version";
  };

<<<<<<< HEAD
  meta = {
    description = "Command-line client of the StackRox Kubernetes Security Platform";
    mainProgram = "roxctl";
    license = lib.licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with lib.maintainers; [ stehessel ];
=======
  meta = with lib; {
    description = "Command-line client of the StackRox Kubernetes Security Platform";
    mainProgram = "roxctl";
    license = licenses.asl20;
    homepage = "https://www.stackrox.io";
    maintainers = with maintainers; [ stehessel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
