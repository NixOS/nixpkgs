{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-03-26";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "074930a23bc89a5f720a0d46ac2853f3153817c2";
    hash = "sha256-XqiUPAVM6OuyNo9HbBKW+OKQrE7QbSjDRtyfmIYQRxs=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-heHFiW1/2qV6BJH7Y0ObSV1sPfVaU0m2KLbASdzca8s=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/074930a23bc89a5f720a0d46ac2853f3153817c2
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
