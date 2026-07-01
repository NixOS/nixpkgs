{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule {
  pname = "cc-token";
  version = "unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "iota-uz";
    repo = "cc-token";
    rev = "c833f5739c4f14c7091337d3291176bf566aed73";
    hash = "sha256-BGeU6ewgoQlZl2LlNpEU2v6pT0wzQmcENnH02jQXpLQ=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-isnQwGIFPon1STxHY/X87SYRMz8VqpBOJ0aeUF9hf9o=";

  postInstall = ''
    export ANTHROPIC_API_KEY=placeholder
    installShellCompletion --cmd cc-token \
      --bash <($out/bin/cc-token completion bash) \
      --zsh  <($out/bin/cc-token completion zsh) \
      --fish <($out/bin/cc-token completion fish)
  '';

  __structuredAttrs = true;

  meta = {
    description = "CLI tool for counting tokens in files using Anthropic's Claude API";
    homepage = "https://github.com/iota-uz/cc-token";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "cc-token";
  };
}
