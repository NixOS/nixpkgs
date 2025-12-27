{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfspeedtest";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MWVWYA++gxcKcCvBynVmm+l3qoSb6JKUtGUbRWEGrP8=";
  };

  cargoHash = "sha256-Oa+k+iBkKFdDcMAxrDdLNWhy2CakbX1G+AMlwGQFBsk=";

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
