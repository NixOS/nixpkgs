{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-09-03";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "08f332ba7abe915575dd0588e7a528a774906b92";
    hash = "sha256-klrQf+myTOUt4NwyF7T/8e01O1+fe7UeNgd6pQBE14g=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-Fb2A9DcYCIdSWrFg4MqkZJ6ev4VQ/VwrBtZoJLEBOHc=";

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
