{
  buildGoModule,
  stdenv,
  lib,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "deck";
  version = "1.66.0";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iC11IQuN/6SXJ30lmMMwSj/poTXdsnhvt6ckWlFsOS4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${finalAttrs.version}"
    "-X github.com/kong/deck/cmd.COMMIT=${finalAttrs.src.rev}"
  ];

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-2B5pfovavc7u1Qk5qVVCVp6kXZoQsLlG5FE6b3p+cZw=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd deck \
      --bash <($out/bin/deck completion bash) \
      --fish <($out/bin/deck completion fish) \
      --zsh <($out/bin/deck completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configuration management and drift detection tool for Kong";
    homepage = "https://github.com/Kong/deck";
    license = lib.licenses.asl20;
    mainProgram = "deck";
    maintainers = with lib.maintainers; [ liyangau ];
  };
})
