{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "62fd38af2f6536bb19ecc78a4dd0f0e1245c0939";
    hash = "sha256-JG8XCXEdjVERQ9f6ZsYCLXVGN85qPWCQhS2svJYW390=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-KDXC2/1GcJL6qH+L/FzzQCA7kJigtKOfxVDLv5qXYao=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/62fd38af2f6536bb19ecc78a4dd0f0e1245c0939
  postPatch = ''
    substituteInPlace tests/main.rs --replace-fail \
      'const TEST_BINARY: &str = "target/debug/nufmt";' \
      'const TEST_BINARY: &str = "target/${stdenv.hostPlatform.rust.rustcTarget}/release/nufmt";'
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Nushell formatter";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      iogamaster
      khaneliman
    ];
    mainProgram = "nufmt";
  };
}
