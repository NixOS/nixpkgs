{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "gmailctl";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UGX+Q1AF3Y0EE2+w9fjVwSZdtM3aGlbpQpLO9d5wASo=";
  };

  vendorHash = "sha256-VF0jDOVDOrLZBm8SAe5uGlMUOBBb+0zrnkjKkeK9VjU=";

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
