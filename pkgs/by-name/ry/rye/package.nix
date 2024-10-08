{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  installShellFiles,
  pkg-config,

  # buildInputs
  openssl,
  stdenv,
  darwin,

  # passthru
  nix-update-script,
  testers,
  rye,
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "rye";
    rev = "refs/tags/${version}";
    hash = "sha256-JpCa+7SwShfVM4Z+uPo7W2bCEf1QYHxClE/LgGSyFY0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dialoguer-0.10.4" = "sha256-WDqUKOu7Y0HElpPxf2T8EpzAY3mY8sSn9lf0V0jyAFc=";
      "monotrail-utils-0.0.1" = "sha256-ydNdg6VI+Z5wXe2bEzRtavw0rsrcJkdsJ5DvXhbaDE4=";
    };
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk;
      [
        frameworks.CoreServices
        frameworks.SystemConfiguration
        Libsystem
      ]
    );

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rye \
      --bash <($out/bin/rye self completion -s bash) \
      --fish <($out/bin/rye self completion -s fish) \
      --zsh <($out/bin/rye self completion -s zsh)
  '';

  checkFlags = [
    "--skip=utils::test_is_inside_git_work_tree"

    # The following require internet access to fetch a python binary
    "--skip=test_add_and_sync_no_auto_sync"
    "--skip=test_add_autosync"
    "--skip=test_add_dev"
    "--skip=test_add_explicit_version_or_url"
    "--skip=test_add_flask"
    "--skip=test_add_from_find_links"
    "--skip=test_autosync_remember"
    "--skip=test_basic_list"
    "--skip=test_basic_script"
    "--skip=test_basic_tool_behavior"
    "--skip=test_config_empty"
    "--skip=test_config_get_set_multiple"
    "--skip=test_config_incompatible_format_and_show_path"
    "--skip=test_config_save_missing_folder"
    "--skip=test_config_show_path"
    "--skip=test_dotenv"
    "--skip=test_empty_sync"
    "--skip=test_exclude_hashes"
    "--skip=test_fetch"
    "--skip=test_generate_hashes"
    "--skip=test_init_default"
    "--skip=test_init_lib"
    "--skip=test_init_script"
    "--skip=test_lint_and_format"
    "--skip=test_list_never_overwrite"
    "--skip=test_list_not_rye_managed"
    "--skip=test_lockfile"
    "--skip=test_publish_outside_project"
    "--skip=test_version"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = rye; };
  };

  meta = {
    description = "Tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    changelog = "https://github.com/mitsuhiko/rye/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "rye";
  };
}
