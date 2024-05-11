{ lib, buildGoModule, fetchFromGitHub, testers, installShellFiles, myks, }:

buildGoModule rec {
  pname = "myks";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "mykso";
    repo = "myks";
    rev = "v${version}";
    hash = "sha256-PaA8j4BWijhPR3DTZ0nnO54v0Uj/DpFdJpofseTA1+A=";
  };

  vendorHash = "sha256-A30SyqgAeYwgiYLZF9M3iW2u8JXPU6ozUThziCmSRgU=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=nixpkg-${src.rev}"
    "-X main.date=1970-01-01"
  ];

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = myks; };

  postInstall = ''
    installShellCompletion --cmd myks \
      --bash <($out/bin/myks completion bash) \
      --zsh <($out/bin/myks completion zsh) \
      --fish <($out/bin/myks completion fish)
  '';

  meta = with lib; {
    changelog = "https://github.com/mykso/myks/blob/main/CHANGELOG.md";
    description = "A configuration framework for Kubernetes applications";
    license = licenses.mit;
    homepage = "https://github.com/mykso/myks";
    maintainers = [ maintainers.kbudde ];
    mainProgram = "myks";
  };
}
