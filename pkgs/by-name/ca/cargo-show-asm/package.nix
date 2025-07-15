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
  version = "0.2.51";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7ck3VjhU+MPCehxKGkC2N4QU8m6U5lFFxyQkgFzHGrc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QhHxyICiluudUMNM66wFq3L/SRxW0FupCz26q+UU1/0=";

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
