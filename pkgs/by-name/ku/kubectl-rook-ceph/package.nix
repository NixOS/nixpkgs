{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rook-ceph";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rook";
    repo = "kubectl-rook-ceph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1UgcFRp9XCuteBVrrD0vy4iG44/LU/PFeXPv49ZQtkQ=";
  };

  vendorHash = "sha256-rWWZRXMrEhMaxorogQqcz2g7KcULMlgQbs+lXDSGY10=";

  # The log completion test starts a local HTTP server.
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubectl-rook-ceph
  '';
  # FIXME: uncomment once https://github.com/rook/kubectl-rook-ceph/issues/353 has been resolved
  # nativeBuildInputs = [ installShellFiles ];
  # postInstall =
  #   ''
  #     ln -s $out/bin/cmd $out/bin/kubectl-rook-ceph
  #   ''
  #   + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
  #     let
  #       emulator = stdenv.hostPlatform.emulator buildPackages;
  #     in
  #     ''
  #       installShellCompletion --cmd kubectl-rook-ceph \
  #       --bash <(${emulator} $out/bin/kubectl-rook-ceph completion bash) \
  #       --fish <(${emulator} $out/bin/kubectl-rook-ceph completion fish) \
  #       --zsh <(${emulator} $out/bin/kubectl-rook-ceph completion zsh)
  #     ''
  #   );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Krew plugin to run kubectl commands with rook-ceph";
    mainProgram = "kubectl-rook-ceph";
    homepage = "https://github.com/rook/kubectl-rook-ceph";
    changelog = "https://github.com/rook/kubectl-rook-ceph/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vinylen ];
  };
})
