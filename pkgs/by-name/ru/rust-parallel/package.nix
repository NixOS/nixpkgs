{
  bash,
  fetchFromGitHub,
  lib,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-parallel";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "aaronriekenberg";
    repo = "rust-parallel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-86CUFtq6XpTYL7zpDBBfbSXlPYhWofwMjJSK698lclI=";
  };

  cargoHash = "sha256-g2R3dEvDv3uzZVXBFvsCoX/M0XuHhoE/mMHni6qEN1g=";

  postPatch = ''
    substituteInPlace tests/dummy_shell.sh \
      --replace-fail "/bin/bash" "${bash}/bin/bash"
  '';

  checkFlags = [
    "--skip=runs_echo_commands_dry_run"
    "--skip=test_keep_order_with_sleep"

    "--skip=runs_regex_command_with_dollar_signs"
    "--skip=runs_regex_from_command_line_args_nomatch_1"
    "--skip=runs_regex_from_input_file_badline_j1"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust shell tool to run commands in parallel with a similar interface to GNU parallel";
    homepage = "https://github.com/aaronriekenberg/rust-parallel";
    license = lib.licenses.mit;
    mainProgram = "rust-parallel";
    maintainers = with lib.maintainers; [ sedlund ];
  };
})
