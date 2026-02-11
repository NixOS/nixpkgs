{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  git,
  uv,
  python312,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J4onCCHZ6DT2CtZ8q0nrdOI74UGDJhVFG2nWj+p7moE=";
  };

  cargoHash = "sha256-pR5NibzX5m8DcMxer0W1wowTJCesYaF852wpGiVboVg=";

  nativeBuildInputs = [
    installShellFiles
  ];

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

    export UV_PROJECT_ENVIRONMENT="$(mktemp -d)"
    cleanup() {
        rm -rf "$UV_PROJECT_ENVIRONMENT"
        rm -rf "$TEMP"
    }
    trap cleanup EXIT
  '';

  __darwinAllowLocalNetworking = true;
  useNextest = true;

  # some python tests use uv, which in turn needs python
  env = {
    UV_PYTHON = "${python312}/bin/python";
    UV_NO_MANAGED_PYTHON = true;
    UV_SYSTEM_PYTHON = true;
  };

  cargoTestFlags = [ "--no-fail-fast" ];

  checkFlags =
    lib.concatMap
      (t: [
        "--skip"
        "${t}"
      ])
      [
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
        "run_worktree"
        "try_repo_relative_path"
        "languages::tests::test_native_tls"
        "rust::additional_dependencies_cli"
        "rust::rustup_installer"
        "rust::remote_hooks"
        "rust::remote_hooks_with_lib_deps"
        "unsupported::unsupported_language"
        "remote_hook_non_workspace"
        "bun::additional_dependencies"
        "bun::basic_bun"
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
        "ruby::additional_gem_dependencies"
        "ruby::environment_isolation"
        "ruby::gemspec_workflow"
        "ruby::language_version_default"
        "ruby::local_hook_with_gemspec"
        "ruby::native_gem_dependency"
        "ruby::native_gem_dependency"
        "ruby::process_files"
        "ruby::specific_ruby_available"
        "ruby::specific_ruby_unavailable"
        "ruby::system_ruby"
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
        "check_merge_conflict_hook"
        "check_merge_conflict_without_assume_flag"
        "check_symlinks_hook_unix"
        "check_xml_hook"
        "check_xml_with_features"
        "detect_private_key_hook"
        "no_commit_to_branch_hook"
        "no_commit_to_branch_hook_with_custom_branches"
        "no_commit_to_branch_hook_with_patterns"
        "check_executables_have_shebangs_various_cases"
        "check_executables_have_shebangs_hook"
        "cache_gc_removes_unreferenced_entries"
        # does not properly use TMP
        "hook_impl"
        # problems with environment
        "try_repo_specific_hook"
        "try_repo_specific_rev"
        # lua path is hardcoded
        "lua::additional_dependencies"
        "lua::health_check"
        "lua::hook_stderr"
        "lua::lua_environment"
        "lua::remote_hook"
        # error message differs
        "run_in_non_git_repo"
        # depends on locale
        "init_nonexistent_repo"
        # https://github.com/astral-sh/uv/issues/8635
        "alternate_config_file"
        "basic_discovery"
        "cache_gc_keeps_local_hook_env"
        "color"
        "cookiecutter_template_directories_are_skipped"
        "empty_entry"
        "git_dir_respected"
        "git_env_vars_not_leaked_to_pip_install"
        "gitignore_respected"
        "invalid_entry"
        "local_python_hook"
        "orphan_projects"
        "run_with_selectors"
        "run_with_stdin_closed"
        "show_diff_on_failure"
        "submodule_discovery"
        "workspace_install_hooks"
        # We don't have git info; we run versionCheckHook instead
        "version_info"
      ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd prek \
      --bash <(COMPLETE=bash $out/bin/prek) \
      --fish <(COMPLETE=fish $out/bin/prek) \
      --zsh <(COMPLETE=zsh $out/bin/prek)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Better `pre-commit`, re-engineered in Rust ";
    mainProgram = "prek";
    changelog = "https://github.com/j178/prek/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.knl ];
  };
})
