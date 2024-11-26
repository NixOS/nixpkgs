{
  buildPythonPackage,
  lib,
  setuptools,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  git,
  coreutils,
  versioneer,
  # core
  platformdirs,
  chardet,
  iso8601,
  humanize,
  fasteners,
  packaging,
  patool,
  tqdm,
  annexremote,
  looseversion,
  git-annex,
  # downloaders
  boto3,
  keyrings-alt,
  keyring,
  msgpack,
  requests,
  # publish
  python-gitlab,
  # misc
  argcomplete,
  pyperclip,
  python-dateutil,
  # duecredit
  duecredit,
  distro,
  # win
  colorama,
  # python-version-dependent
  pythonOlder,
  importlib-metadata,
  typing-extensions,
  # tests
  pytest-xdist,
  pytestCheckHook,
  p7zip,
  curl,
  httpretty,
}:

buildPythonPackage rec {
  pname = "datalad";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "datalad";
    repo = "datalad";
    rev = "refs/tags/${version}";
    hash = "sha256-l3II9xebSq09He5e4GGGiGtfe6ERtIQD00eHKGx46WA=";
  };

  postPatch = ''
    substituteInPlace datalad/distribution/create_sibling.py \
      --replace-fail "/bin/ls" "${coreutils}/bin/ls"
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  nativeBuildInputs = [
    installShellFiles
    git
  ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies =
    optional-dependencies.core ++ optional-dependencies.downloaders ++ optional-dependencies.publish;

  optional-dependencies = {
    core =
      [
        platformdirs
        chardet
        distro
        iso8601
        humanize
        fasteners
        packaging
        patool
        tqdm
        annexremote
        looseversion
      ]
      ++ lib.optionals stdenv.hostPlatform.isWindows [ colorama ]
      ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ]
      ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ];
    downloaders = [
      boto3
      keyrings-alt
      keyring
      msgpack
      requests
    ];
    downloaders-extra = [
      # requests-ftp # not in nixpkgs yet
    ];
    publish = [ python-gitlab ];
    misc = [
      argcomplete
      pyperclip
      python-dateutil
    ];
    duecredit = [ duecredit ];
  };

  postInstall = ''
    installShellCompletion --cmd datalad \
         --bash <($out/bin/datalad shell-completion) \
         --zsh  <($out/bin/datalad shell-completion)
    wrapProgram $out/bin/datalad --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  # tests depend on apps in $PATH which only will get installed after the test
  disabledTests = [
    # No such file or directory: 'datalad'
    "test_script_shims"
    "test_cfg_override"
    "test_completion"
    "test_nested_pushclone_cycle_allplatforms"
    "test_create_sub_gh3463"
    "test_create_sub_dataset_dot_no_path"
    "test_cfg_passthrough"
    "test_addurls_stdin_input_command_line"
    "test_run_datalad_help"
    "test_status_custom_summary_no_repeats"
    "test_quoting"

    #  No such file or directory: 'git-annex-remote-[...]"
    "test_create"
    "test_ensure_datalad_remote_maybe_enable"

    # "git-annex: unable to use external special remote git-annex-remote-datalad"
    "test_ria_postclonecfg"
    "test_ria_postclone_noannex"
    "test_ria_push"
    "test_basic_scenario"
    "test_annex_get_from_subdir"
    "test_ensure_datalad_remote_init_and_enable_needed"
    "test_ensure_datalad_remote_maybe_enable[False]"
    "test_ensure_datalad_remote_maybe_enable[True]"
    "test_create_simple"
    "test_create_alias"
    "test_storage_only"
    "test_initremote"
    "test_read_access"
    "test_ephemeral"
    "test_initremote_basic_fileurl"
    "test_initremote_basic_httpurl"
    "test_remote_layout"
    "test_version_check"
    "test_gitannex_local"
    "test_push_url"
    "test_url_keys"
    "test_obtain_permission_root"
    "test_source_candidate_subdataset"
    "test_update_fetch_all"
    "test_add_archive_dirs"
    "test_add_archive_content"
    "test_add_archive_content_strip_leading"
    "test_add_archive_content_zip"
    "test_add_archive_content_absolute_path"
    "test_add_archive_use_archive_dir"
    "test_add_archive_single_file"
    "test_add_delete"
    "test_add_archive_leading_dir"
    "test_add_delete_after_and_drop"
    "test_add_delete_after_and_drop_subdir"
    "test_override_existing_under_git"
    "test_copy_file_datalad_specialremote"
    "test_download_url_archive"
    "test_download_url_archive_from_subdir"
    "test_download_url_archive_trailing_separator"
    "test_download_url_need_datalad_remote"
    "test_datalad_credential_helper - assert False"

    # need internet access
    "test_clone_crcns"
    "test_clone_datasets_root"
    "test_reckless"
    "test_autoenabled_remote_msg"
    "test_ria_http_storedataladorg"
    "test_gin_cloning"
    "test_nonuniform_adjusted_subdataset"
    "test_install_datasets_root"
    "test_install_simple_local"
    "test_install_dataset_from_just_source"
    "test_install_dataset_from_just_source_via_path"
    "test_datasets_datalad_org"
    "test_get_cached_dataset"
    "test_cached_dataset"
    "test_cached_url"
    "test_anonymous_s3"
    "test_protocols"
    "test_get_versioned_url_anon"
    "test_install_recursive_github"
    "test_failed_install_multiple"

    # pbcopy not found
    "test_wtf"

    # CommandError: 'git -c diff.ignoreSubmodules=none -c core.quotepath=false ls-files -z -m -d' failed with exitcode 128
    "test_subsuperdataset_save"
  ];

  nativeCheckInputs = [
    p7zip
    pytest-xdist
    pytestCheckHook
    git-annex
    curl
    httpretty
  ];

  pythonImportsCheck = [ "datalad" ];

  meta = {
    description = "Keep code, data, containers under control with git and git-annex";
    homepage = "https://www.datalad.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renesat ];
  };
}
