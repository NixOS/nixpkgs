{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-07-05";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "de410853fc4d0f04e101a2573ebba8c15978ea33";
    hash = "sha256-tNdoHiSZRi0PMUtlHqD5vjjPNDzNyZ73QnCOw8rmEPs=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-MLfhuFjYv2Vi3BGJFzbmi+xhhm6M0a4oOe7wpHtfObc=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/de410853fc4d0f04e101a2573ebba8c15978ea33
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
