{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "7cfd3b7eacf5a9feb22777230e3076038f2e9e8d";
    hash = "sha256-v490Rlrih2R1zyGlHbOWzOFn5UTNb6Wx3v7LKLxXahY=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-Fb2A9DcYCIdSWrFg4MqkZJ6ev4VQ/VwrBtZoJLEBOHc=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/7cfd3b7eacf5a9feb22777230e3076038f2e9e8d
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
