{
  lib,
  rustPlatform,
  fetchFromGitHub,
  bpf-linker,
  installShellFiles,
  nix-update-script,
  # Also build the eBPF host blocker and its privileged loader.
  withEbpf ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jail-ai";
  # Upstream forgot to bump Cargo.toml for this tag; fixed on master since.
  version = "0.46.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cyrinux";
    repo = "jail-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iVyCkVIFaWnhjSQoLp7KrNHGb/Ke1Y0TULU0b7ZWimk=";
  };

  cargoHash = "sha256-HgCT59fp3TJMANBMsZTGu0rPQmSCGS8W+LziqtFy0Ik=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals withEbpf [
    bpf-linker
  ];

  cargoBuildFlags = [
    "--package"
    "jail-ai"
  ]
  ++ lib.optionals withEbpf [
    "--package"
    "jail-ai-ebpf-loader"
  ];

  cargoTestFlags = [
    "--package"
    "jail-ai"
  ];

  checkFlags = [
    # Requires /tmp to exist.
    "--skip=cli::tests::test_parse_mount"
  ];

  # The loader include_bytes!s this object, so build it first. Unlike upstream we
  # need no nightly -Zbuild-std: our rustc ships core for bpfel-unknown-none.
  preBuild = lib.optionalString withEbpf ''
    (
      export RUSTC_BOOTSTRAP=1
      export RUSTFLAGS="-C target-feature="
      cargo build --offline --release \
        --target bpfel-unknown-none \
        --package jail-ai-ebpf
    )
  '';

  postInstall = ''
    installManPage docs/jail-ai.1
  '';

  passthru = {
    inherit withEbpf;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Podman-based sandbox for AI coding agents";
    longDescription = ''
      Runs AI coding agents in podman containers with the working directory
      mounted at /workspace, resource limits, network isolation and an eBPF
      filter that blocks access to the host's own IP addresses.
    '';
    homepage = "https://github.com/cyrinux/jail-ai";
    changelog = "https://github.com/cyrinux/jail-ai/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    mainProgram = "jail-ai";
    platforms = lib.platforms.linux;
  };
})
