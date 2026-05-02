{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  bash,
  protobuf,
  protoc-gen-go,
  protoc-gen-go-grpc,
  kubernetes-controller-tools,
  installShellFiles,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "dcp";
  version = "0.23.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "dcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WbxFD7hq9WIfzGm3lKqr2cckUjoWwiVMNH8I7LvVSWg=";
  };

  vendorHash = "sha256-f5NcEgkBzOdYqBdVGYoL8EYew6LXmZwpNiIQeoett/k=";

  # This is required so we:
  # - Delete an inconsistent vendor directory from upstream
  # - Avoid running a preBuild before the codegen step
  overrideModAttrs = _: {
    preBuild = null;
    postUnpack = ''
      rm -rf $sourceRoot/vendor
    '';
  };

  nativeBuildInputs = [
    installShellFiles
    protoc-gen-go
    protoc-gen-go-grpc
    writableTmpDirAsHomeHook
  ];

  # Run code generation using the upstream Makefile.
  # Override SHELL for Nix sandbox compatibility.
  # Use full paths for PROTOC and CONTROLLER_GEN to avoid Makefile target conflicts.
  preBuild = ''
    make generate \
      SHELL="${bash}/bin/bash -o pipefail" \
      PROTOC="${protobuf}/bin/protoc" \
      CONTROLLER_GEN="${kubernetes-controller-tools}/bin/controller-gen"
  '';

  subPackages = [
    "cmd/dcp"
    "cmd/dcptun"
  ];

  ldflags =
    let
      pkg = "github.com/microsoft/dcp/internal/version";
    in
    [
      "-s"
      "-w"
      "-X ${pkg}.ProductVersion=${finalAttrs.version}"
      "-X ${pkg}.CommitHash=v${finalAttrs.version}"
    ];

  # The dcptun binary should be named dcptun_c for compatibility
  # https://github.com/microsoft/dcp/blob/3146b1dd5b2ea283947f846a55bf2e01c294e2ba/Makefile#L103
  postInstall = ''
    mv $out/bin/dcptun $out/bin/dcptun_c
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd dcp \
      --bash <($out/bin/dcp completion bash) \
      --fish <($out/bin/dcp completion fish) \
      --zsh <($out/bin/dcp completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Developer Control Plane - API server and CLI for managing developer workloads";
    homepage = "https://github.com/microsoft/dcp";
    changelog = "https://github.com/microsoft/dcp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mtrsk ];
    mainProgram = "dcp";
    platforms = lib.platforms.unix;
  };
})
