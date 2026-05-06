{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  # linux dependencies
  makeWrapper,
  bubblewrap,
  socat,
  bpftrace,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "fence";
  version = "0.1.57";

  src = fetchFromGitHub {
    owner = "Use-Tusk";
    repo = "fence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YX+DqD20hr/+hAXLVddEQjj0J7jybhNNdtQM3tlSPek=";
  };

  vendorHash = "sha256-Qct/M0zuggYzlN0gyO8nF58M5Av3HcYyMjrPab5Crr0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.gitCommit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

  # Tests want to create sandbox profiles on darwin.
  # Nested sandboxes are unsupported by seatbelt, which means we cannot execute the tests inside the nix build sandbox.
  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [
    bubblewrap
    socat
    bpftrace
  ];

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
        --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
        --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
        --suffix PATH : ${
          lib.makeBinPath [
            bubblewrap
            socat
            bpftrace
          ]
        }
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight, container-free sandbox for running commands with network and filesystem restrictions";
    homepage = "https://github.com/Use-Tusk/fence";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwt ];
    mainProgram = "fence";
  };
})
