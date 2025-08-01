{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gotlsaflare";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "Stenstromen";
    repo = "gotlsaflare";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MryKBTFTdjoi8Bn39kCcyCVsj/C/lPJUaEgliLkHXuQ=";
  };

  vendorHash = "sha256-ZC1OD7TYE0CL8Vsopgeh+K13Rcm0mI9I2BpdDNpDSWE=";

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
