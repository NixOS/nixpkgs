{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-05-24";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "a24c2b1bc7f573b1a8b2c4a453e989407a4d29c8";
    hash = "sha256-3AOxUXDd6LDgBqKPnHG+3K2qfcFGzIsPW3pqnt+oNs8=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-MLfhuFjYv2Vi3BGJFzbmi+xhhm6M0a4oOe7wpHtfObc=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/a24c2b1bc7f573b1a8b2c4a453e989407a4d29c8
  postPatch = ''
    substituteInPlace tests/ground_truth.rs --replace-fail \
      '        let path = PathBuf::from(target_dir).join("debug").join(exe_name);' \
      '        let path = PathBuf::from(target_dir).join("${stdenv.hostPlatform.rust.rustcTarget}/release").join(exe_name);'
    substituteInPlace tests/ground_truth.rs --replace-fail \
      '    let default_path = PathBuf::from("target").join("debug").join(exe_name);' \
      '    let default_path = PathBuf::from("target").join("${stdenv.hostPlatform.rust.rustcTarget}/release").join(exe_name);'
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
