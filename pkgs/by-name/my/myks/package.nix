{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  installShellFiles,
  myks,
  stdenv,
}:

buildGoModule rec {
  pname = "myks";
  version = "4.8.3";

  src = fetchFromGitHub {
    owner = "mykso";
    repo = "myks";
    tag = "v${version}";
    hash = "sha256-heAIVvQdb69XO3xP6Xq7+5/FqaKrie/1JxJ8FyFXw/U=";
  };

  vendorHash = "sha256-G+wr4mDuQoZEgdyHohDSVUJza70eZc+zrmQ79d/49lE=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=nixpkg-${version}"
    "-X=main.date=1970-01-01"
  ];

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  passthru.tests.version = testers.testVersion { package = myks; };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
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
    maintainers = [
      maintainers.kbudde
      maintainers.zebradil
    ];
    mainProgram = "myks";
  };
}
