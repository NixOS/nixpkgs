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
  version = "0.1.61";

  src = fetchFromGitHub {
    owner = "fencesandbox";
    repo = "fence";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/IVxTPgAzl+mX85M1IyD+21O8j/tIxt2a18TLtQz/zk=";
  };

  vendorHash = "sha256-aMxay3dow6mDKyv396R0j1GOKDmhkX4ebGmhca1B4WE=";

  __structuredAttrs = true;

  subPackages = [
    "cmd/fence"
  ];

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
    homepage = "https://fencesandbox.com";
    changelog = "https://github.com/jy-tan/fence/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwt ];
    mainProgram = "fence";
  };
})
