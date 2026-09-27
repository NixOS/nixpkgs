{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jq-lsp";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "jq-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C32LxOfqCp6rhHKl1JNKq+KSw+TCN7QF6WDMfwfX4zo=";
  };

  vendorHash = "sha256-pGXFuyYJPNcMEd0vPrmbdY/CeOF0AXwrNJEfrBBe4I0=";

  # based on https://github.com/wader/jq-lsp/blob/master/.goreleaser.yml
  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.builtBy=Nix"
  ];

  meta = {
    description = "jq language server";
    homepage = "https://github.com/wader/jq-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sysedwinistrator ];
    mainProgram = "jq-lsp";
  };
})
