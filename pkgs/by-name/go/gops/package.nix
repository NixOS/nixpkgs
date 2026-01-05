{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gops";
  version = "0.3.28";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HNM487WSfNWNF31ccDIdotsEG8Mj2C7V85UI47a9drU=";
  };

  vendorHash = "sha256-ptC2G7cXcAjthJcAXvuBqI2ZpPuSMBqzO+gJiyaAUP0=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd gops \
      --bash <($out/bin/gops completion bash) \
      --fish <($out/bin/gops completion fish) \
      --zsh <($out/bin/gops completion zsh)
  '';

  meta = with lib; {
    description = "Tool to list and diagnose Go processes currently running on your system";
    mainProgram = "gops";
    homepage = "https://github.com/google/gops";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pborzenkov ];
  };
})
