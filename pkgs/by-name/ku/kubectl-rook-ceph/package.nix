{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-rook-ceph";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "rook";
    repo = "kubectl-rook-ceph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t63m5cUIApAOBF1Nb8u2/Xkyi1OAGnaLSVWFyLec8AA=";
  };

  vendorHash = "sha256-8KrTfryEiTqF13NQ5xS1d9mIZI3ranA8+EkKUHu2mVE=";

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
