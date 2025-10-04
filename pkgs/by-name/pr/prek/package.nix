{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  uv,
  python312,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-52NTG+cZLOxCJZvDSZ9vqsyH+J8U38aGlQdWQ2dFOWE=";
  };

  cargoHash = "sha256-SYJ+ABvIoOW0O+28ofM8YXJwIlFkR84yDZaaehhx0Ks=";

  preBuild = ''
    version312_str=$(${python312}/bin/python -c 'import sys; print(sys.version_info[:3])')

    substituteInPlace ./tests/languages/python.rs \
      --replace '(3, 12, 11)' "$version312_str"
  '';

  nativeCheckInputs = [
    git
    python312
    uv
  ];

  preCheck = ''
    export TEMP="$(mktemp -d)"
    export TMP=$TEMP
    export TMPDIR=$TEMP
    export PREK_INTERNAL__TEST_DIR=$TEMP
  '';

  __darwinAllowLocalNetworking = true;
  useNextest = true;

  # some python tests use uv, which in turn needs python
  UV_PYTHON = "${python312}/bin/python";

  checkFlags = builtins.map (t: "--skip ${t}") [
    # these tests require internet access
    "check_added_large_files_hook"
    "check_json_hook"
    "end_of_file_fixer_hook"
    "mixed_line_ending_hook"
    "install_hooks_only"
    "install_with_hooks"
    "golang"
    "node"
    "script"
    "check_useless_excludes_remote"
    # "meta_hooks"
    "reuse_env"
    "docker::docker"
    "docker::workspace_docker"
    "docker_image::docker_image"
    "pygrep::basic_case_sensitive"
    "pygrep::case_insensitive"
    "pygrep::case_insensitive_multiline"
    "pygrep::complex_regex_patterns"
    "pygrep::invalid_args"
    "pygrep::invalid_regex"
    "pygrep::multiline_mode"
    "pygrep::negate_mode"
    "pygrep::negate_multiline_mode"
    "pygrep::pattern_not_found"
    "pygrep::python_regex_quirks"
    "python::additional_dependencies"
    "python::can_not_download"
    "python::hook_stderr"
    "python::language_version"
    # can't checkout pre-commit-hooks
    "cjk_hook_name"
    "fail_fast"
    "file_types"
    "files_and_exclude"
    "git_commit_a"
    "log_file"
    "merge_conflicts"
    "pass_env_vars"
    "restore_on_interrupt"
    "run_basic"
    "run_last_commit"
    "same_repo"
    "skips"
    "staged_files_only"
    "subdirectory"
    "check_yaml_hook"
    "check_yaml_multiple_document"
    "builtin_hooks_workspace_mode"
    "fix_byte_order_marker_hook"
    "fix_byte_order_marker"
    # does not properly use TMP
    "hook_impl"
  ];

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Better `pre-commit`, re-engineered in Rust ";
    mainProgram = "prek";
    changelog = "https://github.com/j178/prek/releases/tag/${finalAttrs.src.tag}";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.knl ];
  };
})
