{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prmt";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "prmt";
    owner = "3axap4eHko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pLxWArZzGU1vjS2DOJ6PyrhYC2XbkAD5SfiFjHTaQfI=";
  };

  cargoHash = "sha256-hmtKmnSnSGgivY+dmC4WlMuCJGTVM6GI5k0pZcfzYso=";

  # Fail to run in sandbox environment
  checkFlags = map (t: "--skip=${t}") [
    "test_git_module"
    "modules::git::tests::empty_dir_tree_not_reported_as_untracked"
    "modules::git::tests::empty_repo_has_no_untracked_status_in_gix_path"
    "modules::git::tests::empty_repo_has_no_untracked_status_in_slow_path"
    "modules::git::tests::untracked_file_sets_untracked_status_in_gix_path"
    "modules::git::tests::xdg_ignored_progress_dir_does_not_set_untracked_status"
    "modules::git::tests::xdg_ignored_progress_dir_stays_clean_in_gix_path"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultra-fast, customizable shell prompt generator";
    homepage = "https://github.com/3axap4eHko/prmt";
    changelog = "https://github.com/3axap4eHko/prmt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "prmt";
  };
})
