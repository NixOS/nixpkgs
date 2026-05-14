{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "expenses";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "expenses";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sqsogF2swMvYZL7Kj+ealrB1AAgIe7ZXXDLRdHL6Q+0=";
  };

  vendorHash = "sha256-rIcwZUOi6bdfiWZEsRF4kl1reNPPQNuBPHDOo7RQgYo=";

  # package does not contain any tests as of v0.2.3
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ sqlite ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/manojkarthick/expenses/cmd.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd expenses \
      --bash <($out/bin/expenses completion bash) \
      --zsh <($out/bin/expenses completion zsh) \
      --fish <($out/bin/expenses completion fish)
  '';

  meta = {
    description = "Interactive command line expense logger";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.manojkarthick ];
    mainProgram = "expenses";
  };
})
