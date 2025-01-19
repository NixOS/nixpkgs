{
  lib,
  rustPlatform,
  fetchFromGitHub,
  llvmPackages_12,
  pkg-config,
  openssl,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  installShellFiles,
  stdenv,
  systemd,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "bpfman";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "bpfman";
    repo = "bpfman";
    rev = "v${version}";
    hash = "sha256-HD8Qdy7wvV2zGoPRLYZu+NpG28T5Q4WfLr5UnZB+bkg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-X9qSGSXRX8WEGKD4Wc2iRhmky1uGCspG8muyCsyeIiQ=";

  nativeBuildInputs = [
    llvmPackages_12.llvm
    pkg-config
    installShellFiles
  ];
  buildInputs = [ openssl ];

  postInstall =
    ''
      compdir=./.output/completions
      cargo xtask build-completion
      installShellCompletion --cmd bpfman \
        --bash $compdir/bpfman.bash \
        --fish $compdir/bpfman.fish
    ''
    + lib.optionalString enableSystemd ''
      mkdir -p $out/lib/systemd/system
      cp scripts/bpfman.socket $out/lib/systemd/system
      substitute scripts/bpfman.service \
                 $out/lib/systemd/system/bpfman.service \
                 --replace /usr/sbin/bpfman-rpc $out/bin/bpfman-rpc
    '';

  checkFlags = [
    # Tests needing network connectivity
    "--skip=oci_utils::image_manager::tests::image_pull_and_bytecode_verify"
    "--skip=oci_utils::image_manager::tests::image_pull_and_bytecode_verify_legacy"
    "--skip=oci_utils::image_manager::tests::image_pull_failure"
    "--skip=oci_utils::image_manager::tests::image_pull_policy_never_failure"
    "--skip=oci_utils::image_manager::tests::private_image_pull_and_bytecode_verify"
  ];

  meta = {
    description = "An eBPF Manager for Linux and Kubernetes";
    mainProgram = "bpfman";
    homepage = "https://bpfman.io";
    license = with lib.licenses; [
      asl20
      bsd2
      gpl2Only
    ];
    maintainers = with lib.maintainers; [ pizzapim ];
  };
}
