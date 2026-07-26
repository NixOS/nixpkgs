{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ory";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhqUg0rQigCfvbFEGrm+mBsO8ARDCxQztzK+05/4cvc=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 1;

  ldflags = [
    "-X=github.com/ory/cli/buildinfo.Version=v${finalAttrs.version}"
    "-X=github.com/ory/cli/buildinfo.GitHash=${finalAttrs.src.rev}"
  ];

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-CbiFE/kq0w8lFJKlJt3e/ONv3ucLYHec6dWoqAJ3yuk=";
  postInstall = ''
    mv $out/bin/cli $out/bin/ory
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export version=v${finalAttrs.version}
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  meta = {
    description = "CLI for Ory";
    mainProgram = "ory";
    homepage = "https://www.ory.sh/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      luleyleo
      nicolas-goudry
      debtquity
    ];
  };
})
