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
  version = "0.3.29";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gops";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2xY/e+lqE1XtMMOJ+WmbMWibQMCIoEouOXNIJKEikvs=";
  };

  vendorHash = "sha256-mumni9LEUhnJz6RYp1MjjFQd9iXe7V0RjXR+S266WaE=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd gops \
      --bash <($out/bin/gops completion bash) \
      --fish <($out/bin/gops completion fish) \
      --zsh <($out/bin/gops completion zsh)
  '';

  meta = {
    description = "Tool to list and diagnose Go processes currently running on your system";
    mainProgram = "gops";
    homepage = "https://github.com/google/gops";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pborzenkov ];
  };
})
