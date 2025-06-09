{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
  nix-update-script,
  callPackage,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.49";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DH3jE7nGdwIQVHk80EsC4gYh5+wk6VMWS0d+jZYnX1I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R+I6EVzHvI1Et4nvxENc3IvfmSLr/g77x4wCMNb2R88=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cargo-asm \
      --bash <($out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <($out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = lib.optionalAttrs stdenv.hostPlatform.isx86_64 {
      test-basic-x86_64 = callPackage ./test-basic-x86_64.nix { };
    };
  };

  meta = {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    changelog = "https://github.com/pacak/cargo-show-asm/blob/${version}/Changelog.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      figsoda
      oxalica
      matthiasbeyer
    ];
    mainProgram = "cargo-asm";
  };
}
