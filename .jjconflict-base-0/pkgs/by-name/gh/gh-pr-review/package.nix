{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gh-pr-review";
  version = "1.6.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agynio";
    repo = "gh-pr-review";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NVctUkxfYGs29T9naAfqbEhUXfhynx8Ajsh+V+4gCLw=";
  };

  vendorHash = "sha256-CEV23koYz0FpSWXJRF4J+dGNuDT8Ftkn4LGFftvd0ts=";

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gh-pr-review \
      --zsh <($out/bin/gh-pr-review completion zsh) \
      --fish <($out/bin/gh-pr-review completion fish) \
      --bash <($out/bin/gh-pr-review completion bash)
  '';

  meta = {
    description = "GitHub CLI extension that adds full inline PR review comment support";
    homepage = "https://github.com/agynio/gh-pr-review";
    changelog = "https://github.com/agynio/gh-pr-review/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "gh-pr-review";
  };
})
