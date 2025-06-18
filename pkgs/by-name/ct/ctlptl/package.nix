{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.42";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = "ctlptl";
    rev = "v${version}";
    hash = "sha256-aMpQbWdAIRQ8mBQkzf3iGsLezU7jHVQK2KXzyBnUFJ0=";
  };

  vendorHash = "sha256-kxayiAymEHnZ+b/a7JgUx3/I5gnNEdg+Vg5ymMO9JG8=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/ctlptl" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd ctlptl \
      --bash <($out/bin/ctlptl completion bash) \
      --fish <($out/bin/ctlptl completion fish) \
      --zsh <($out/bin/ctlptl completion zsh)
  '';

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
