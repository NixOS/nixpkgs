{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-07-23";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "f4c2e3bfb9cfff0a430c513ad2198634412e22a1";
    hash = "sha256-bElMaIou3kvYBCEwTAgdG8a7Ug2R7P6giwSHmdrtinI=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-MLfhuFjYv2Vi3BGJFzbmi+xhhm6M0a4oOe7wpHtfObc=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/f4c2e3bfb9cfff0a430c513ad2198634412e22a1
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
