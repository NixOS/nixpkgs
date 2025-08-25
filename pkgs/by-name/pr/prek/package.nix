{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
  python312,
  python313,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nFYgbCfBeaK2qUE1403xUYvec5ZUQW135OVtz56Pgqg=";
  };

  cargoHash = "sha256-VGMkMWB/sQMdX9fBJ1hAPvFYyE/BVIQZg1xvRm16vrk=";

  preBuild = ''
    version312_str=$(${python312}/bin/python -c 'import sys; print(sys.version_info[:3])')
    version313_str=$(${python313}/bin/python -c 'import sys; print(sys.version_info[:3])')

    substituteInPlace ./tests/languages/python.rs \
      --replace '(3, 12, 11)' "$version312_str" \
      --replace '(3, 13, 5)' "$version313_str"
  '';

  nativeCheckInputs = [
    git
    python312
    python313
  ];

  preCheck = ''
    export TEMP="$(mktemp -d)"
    export TMP=$TEMP
    export PREK_INTERNAL__TEST_DIR=$TEMP
  '';

  checkFlags = builtins.map (t: "--skip=${t}") [
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
    "meta_hooks"
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
    # does not properly use TMP
    "hook_impl"
  ];

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Better `pre-commit`, re-engineered in Rust ";
    changelog = "https://github.com/j178/prek/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ knl ];
  };
})
