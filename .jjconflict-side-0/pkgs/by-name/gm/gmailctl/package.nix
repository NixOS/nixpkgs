{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gmailctl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3E45ZQShv+pdlrAfPBtz1Xc8L1GU7FaJRDdTYHitC18=";
  };

  vendorHash = "sha256-yyJjrqkXcRKVAM5qkd92jOp2pD3n+Gm/divTw+EyiLo=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gmailctl \
      --bash <($out/bin/gmailctl completion bash) \
      --fish <($out/bin/gmailctl completion fish) \
      --zsh <($out/bin/gmailctl completion zsh)
  '';

  doCheck = false;

  meta = {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      doronbehar
      SuperSandro2000
    ];
  };
})
