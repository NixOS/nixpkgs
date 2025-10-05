{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2025-06-19";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "35962223fbd4c1a924b4ccfb8c7ad81fe2863b86";
    hash = "sha256-2WgqKQBZRMqUyWq0qm+d8TUT/iAQ1LZjhllBKqimp+Q=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-KDXC2/1GcJL6qH+L/FzzQCA7kJigtKOfxVDLv5qXYao=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/35962223fbd4c1a924b4ccfb8c7ad81fe2863b86
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
      khaneliman
    ];
    mainProgram = "nufmt";
  };
}
