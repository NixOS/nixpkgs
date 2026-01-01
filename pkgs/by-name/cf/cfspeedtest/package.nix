{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfspeedtest";
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "1.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-MWVWYA++gxcKcCvBynVmm+l3qoSb6JKUtGUbRWEGrP8=";
  };

  cargoHash = "sha256-Oa+k+iBkKFdDcMAxrDdLNWhy2CakbX1G+AMlwGQFBsk=";
=======
    hash = "sha256-MWHZllH0QVylmvwEwCX2uhNSEx9p5xEeW0u/zGyjNZE=";
  };

  cargoHash = "sha256-wTytRbue26KVaGb3LarTCNdq56psIayVDul4iQkwH2s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
