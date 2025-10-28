{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gotlsaflare";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "Stenstromen";
    repo = "gotlsaflare";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yf3Z+qO3nF1XgDC0ocbNpUJUvwfhw60F5Y5yG55LsJs=";
  };

  vendorHash = "sha256-d+79m6K1+fy3vyXLKvwNx6mFiO3UO9lHJ07364jVJYM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gotlsaflare \
      --bash <($out/bin/gotlsaflare completion bash) \
      --fish <($out/bin/gotlsaflare completion fish) \
      --zsh <($out/bin/gotlsaflare completion zsh)
  '';

  meta = {
    description = "Update TLSA DANE records on cloudflare from x509 certificates";
    homepage = "https://github.com/Stenstromen/gotlsaflare";
    changelog = "https://github.com/Stenstromen/gotlsaflare/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ szlend ];
    mainProgram = "gotlsaflare";
  };
})
