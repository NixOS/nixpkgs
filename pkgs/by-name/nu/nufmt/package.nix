{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0.1.6-unstable-2026-10-21";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "3dfd39c1499f065285052d0324541b8c26870e57";
    hash = "sha256-FqGRnFFQDc7eY7NmQwMFL/zOqNpI03+0txNttXojjZk=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-MU33Z9Ekp0U1cyEHVu5DyKO3KShJlQuhSg/aisGxlYE=";

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
