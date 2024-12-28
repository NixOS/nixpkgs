{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-benchcmp";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "cargo-benchcmp";
    rev = version;
    hash = "sha256-J8KFI0V/mOhUlYtVnFAQgPIpXL9/dLhOFxSly4bR00I=";
  };

  cargoHash = "sha256-2V9ILHnDsUI+x3f5o+V7p8rPUKf33PAkpyTabCPdd0g=";

  patches = [
    # patch the binary path so tests can find the binary when `--target` is present
    (replaceVars ./fix-test-binary-path.patch {
      shortTarget = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  checkFlags = [
    # thread 'different_input_colored' panicked at 'assertion failed: `(left == right)`
    "--skip=different_input_colored"
  ];

  meta = with lib; {
    description = "Small utility to compare Rust micro-benchmarks";
    mainProgram = "cargo-benchcmp";
    homepage = "https://github.com/BurntSushi/cargo-benchcmp";
    license = with licenses; [
      mit
      unlicense
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
