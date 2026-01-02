{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "poutine";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    tag = "v${version}";
    hash = "sha256-Rk4Fd/h83NKIVlz/QXOSLnCKfxfKFXUfvUF5FSjomQY=";
  };

  vendorHash = "sha256-qp3Ko+01kk9AH0oCT2Si/si+74gT5KFtPFslwih/IBE=";

  ldflags = [
    "-s"
    "-w"
  ];

  # "dagger" directory contains its own go module, which should be excluded from the build
  excludedPackages = [ "dagger" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} completion bash) \
      --fish <($out/bin/${meta.mainProgram} completion fish) \
      --zsh <($out/bin/${meta.mainProgram} completion zsh)
  '';

  meta = {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "poutine";
  };
}
