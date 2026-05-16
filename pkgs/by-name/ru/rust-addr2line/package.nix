{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-addr2line";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "gimli-rs";
    repo = "addr2line";
    tag = version;
    hash = "sha256-+GrX5/AgKlU0rNIKkt4XAQFab6G6F4DN4Qkol8Jd5DQ=";
  };

  cargoBuildFlags = "--bin addr2line --features bin";

  cargoHash = "sha256-aC69kyyMNwifIsjRPCgKxqguKtU7zSN8Mn9tChXykNo=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform `addr2line` clone written in Rust, using `gimli`";
    homepage = "https://github.com/gimli-rs/addr2line";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [
      lib.maintainers.axka
      lib.maintainers.flokli
    ];
    mainProgram = "addr2line";
  };
}
