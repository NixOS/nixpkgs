{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfspeedtest";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KeJ/p9kXfI3OuAyNUx2C6DKpmtL3239uHpWAf4mDr4Q=";
  };

  cargoHash = "sha256-mXSbbY3nuhEw+QUk6gt71HIh2gKNBO6C0trZbyzbpnM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cfspeedtest \
      --bash <($out/bin/cfspeedtest --generate-completion bash) \
      --fish <($out/bin/cfspeedtest --generate-completion fish) \
      --zsh <($out/bin/cfspeedtest --generate-completion zsh)
  '';

  meta = {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    changelog = "https://github.com/code-inflation/cfspeedtest/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      colemickens
      stepbrobd
    ];
    mainProgram = "cfspeedtest";
  };
})
