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
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "mykso";
    repo = "myks";
    tag = "v${version}";
    hash = "sha256-Q8Qtxb+eUaw0eX3F/jkgKKHmjApZ/UsTE+LeJ1FKoCg=";
  };

  vendorHash = "sha256-wHP/l8Evu6F9Kzm88EQv9JMONI3OlWB3jB+88RgzKmo=";

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

  meta = {
    changelog = "https://github.com/mykso/myks/blob/v${version}/CHANGELOG.md";
    description = "Configuration framework for Kubernetes applications";
    license = lib.licenses.mit;
    homepage = "https://github.com/mykso/myks";
    maintainers = [
      lib.maintainers.kbudde
      lib.maintainers.zebradil
    ];
    mainProgram = "myks";
  };
}
