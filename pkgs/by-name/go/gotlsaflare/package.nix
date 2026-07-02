{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gotlsaflare";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "Stenstromen";
    repo = "gotlsaflare";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zw8RfwAR6dw4YUSdML1QJCXVj1s9ZNzr3LTb2vt2fjI=";
  };

  vendorHash = "sha256-OaaIhXh9+iqMBnP4pHxuJMynXxvfY6iiv+Cd4Dq1I+I=";

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
