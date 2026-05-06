{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  installShellFiles,
  myks,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "myks";
  version = "5.12.2";

  src = fetchFromGitHub {
    owner = "mykso";
    repo = "myks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CQCxsuZhqRo5PMahc1UBy5T2SvwDs50JWHmhm4qU3FI=";
  };

  vendorHash = "sha256-BFuJBaOGzttc8Q1ZxMIx0SWnBWmHg7TwU5VG8Wgydb0=";

  subPackages = ".";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=nixpkg-${finalAttrs.version}"
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
    changelog = "https://github.com/mykso/myks/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Configuration framework for Kubernetes applications";
    license = lib.licenses.mit;
    homepage = "https://github.com/mykso/myks";
    maintainers = [
      lib.maintainers.kbudde
      lib.maintainers.zebradil
    ];
    mainProgram = "myks";
  };
})
