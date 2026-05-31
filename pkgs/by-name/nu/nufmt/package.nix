{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "nufmt";
  version = "0-unstable-2026-05-18";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "2a9661dffb7e432b46c0b0956e74e0511e783dc7";
    hash = "sha256-OTKtCQ1AafQ6ejW657mJ1vqtgmZCxKEnNMT/EOsT5ic=";
  };

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  cargoHash = "sha256-jgmNMk2tprJsGU/pddxfKdfWli9dNwLt02LhVhQrHc4=";

  # NOTE: Patch follows similar intention upstream https://github.com/nushell/nufmt/commit/2a9661dffb7e432b46c0b0956e74e0511e783dc7
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
