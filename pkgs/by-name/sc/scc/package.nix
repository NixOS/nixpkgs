{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "scc";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gOr09UzPfmNDUqvGJtmXYdn0gWfcvvVyoBfyRBDSy88=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd scc \
      --bash <($out/bin/scc completion bash) \
      --fish <($out/bin/scc completion fish) \
      --zsh <($out/bin/scc completion zsh)
  '';

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with lib.maintainers; [
      sigma
    ];
    license = with lib.licenses; [
      mit
    ];
  };
})
