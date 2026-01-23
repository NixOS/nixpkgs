{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "c03e166babe7b77f1a80a7916ab1e8e2437bba06";
    hash = "sha256-VZiRmo9/jxAFCSr2bHrf89qb6o1Obwt2+O3NrIrokZo=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-BpKhgF3LUQRL1mNCR5Iq4/Q+eRaOf+JgQCuUfloRhzk=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/35962223fbd4c1a924b4ccfb8c7ad81fe2863b86
  postPatch = ''
    substituteInPlace tests/main.rs --replace-fail \
      'const TEST_BINARY: &str = "target/debug/nufmt";' \
      'const TEST_BINARY: &str = "target/${stdenv.hostPlatform.rust.rustcTarget}/release/nufmt";'
    substituteInPlace tests/ground_truth.rs --replace-fail \
      'const TEST_BINARY: &str = "target/debug/nufmt";' \
      'const TEST_BINARY: &str = "target/${stdenv.hostPlatform.rust.rustcTarget}/release/nufmt";'
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      khaneliman
    ];
    mainProgram = "nufmt";
  };
}
