{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "cae92f70d4f04aca062a9d1ce935dedaa71052f3";
    hash = "sha256-MQ3M/8UmCPt93OLu5ZWkSqbQLZeHpR5QKnzPzu37slw=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-MLfhuFjYv2Vi3BGJFzbmi+xhhm6M0a4oOe7wpHtfObc=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/cae92f70d4f04aca062a9d1ce935dedaa71052f3
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
