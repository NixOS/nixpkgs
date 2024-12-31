{ lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  installShellFiles,
  myks,
  stdenv,
}:

buildGoModule rec {
  pname = "myks";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "mykso";
    repo = "myks";
    rev = "refs/tags/v${version}";
    hash = "sha256-jI5u/xaAt7BOug/okrrRoZXZVJOr+ahGtFJE3PbPQ7k=";
  };

  vendorHash = "sha256-Ka+zVKQBAd6ChOYOw4FYzqJCfdzpN2OppDJsoT/5I0c=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=nixpkg-${version}"
    "-X=main.date=1970-01-01"
  ];

  nativeBuildInputs = [ installShellFiles ];

  CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = myks; };

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd myks \
        --bash <($out/bin/myks completion bash) \
        --zsh <($out/bin/myks completion zsh) \
        --fish <($out/bin/myks completion fish)
    '';

  meta = with lib; {
    changelog = "https://github.com/mykso/myks/blob/v${version}/CHANGELOG.md";
    description = "Configuration framework for Kubernetes applications";
    license = licenses.mit;
    homepage = "https://github.com/mykso/myks";
    maintainers = [ maintainers.kbudde ];
    mainProgram = "myks";
  };
}
