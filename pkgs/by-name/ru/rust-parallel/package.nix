{
  bash,
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-parallel";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "aaronriekenberg";
    repo = "rust-parallel";
    rev = "v${version}";
    hash = "sha256-4f/JE8KWYDdLwx+bCSSbz0Cpfy/g3WIaRzqCvUix4t0=";
  };

  cargoHash = "sha256-bhwA2Acl10Rz5uRxJT+RagDZloeztM2eWJmkHV6Ib6c=";

  postPatch = ''
    substituteInPlace tests/dummy_shell.sh \
      --replace "/bin/bash" "${bash}/bin/bash"
  '';

  checkFlags = [
    "--skip=runs_echo_commands_dry_run"

    "--skip=runs_regex_command_with_dollar_signs"
    "--skip=runs_regex_from_command_line_args_nomatch_1"
    "--skip=runs_regex_from_input_file_badline_j1"
  ];

  meta = {
    description = "Rust shell tool to run commands in parallel with a similar interface to GNU parallel";
    homepage = "https://github.com/aaronriekenberg/rust-parallel";
    license = lib.licenses.mit;
    mainProgram = "rust-parallel";
    maintainers = with lib.maintainers; [ sedlund ];
    platforms = lib.platforms.linux;
  };
}
