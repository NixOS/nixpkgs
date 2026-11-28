{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  less,
  installShellFiles,
  makeWrapper,
  oniguruma,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bat";
  version = "0.27.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "bat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dluJZMmz7aQTp0OQTBwoCoTn7Bd/D+CoIqlaLl9rrss=";
  };

  cargoHash = "sha256-GWafeaone1k8EB+6s6HutVIAC4E1odc+5qRYZuaEopA=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    oniguruma
  ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{bash,fish,zsh}
  '';

  # Insert Nix-built `less` into PATH because the system-provided one may be too old to behave as
  # expected with certain flag combinations.
  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  # Skip test cases which depends on `more`
  checkFlags = [
    "--skip=alias_pager_disable_long_overrides_short"
    "--skip=config_read_arguments_from_file"
    "--skip=diff_plain_does_not_show_grid_or_header"
    "--skip=diff_plain_preserves_change_markers"
    "--skip=diff_skips_files_without_git_information"
    "--skip=diff::tests::diff_is_calculated_against_index_2"
    "--skip=diff::tests::diff_is_calculated_against_index"
    "--skip=diff::tests::diff_is_calculated_correctly"
    "--skip=diff::tests::diff_is_calculated_in_cone_sparse_checkout"
    "--skip=diff::tests::diff_is_calculated_in_sha256_repository"
    "--skip=diff::tests::faulty_git_version_does_not_panic"
    "--skip=diff::tests::filter_from_repository_config_is_not_executed"
    "--skip=enable_pager_if_disable_paging_flag_comes_before_paging"
    "--skip=enable_pager_if_pp_flag_comes_before_paging"
    "--skip=env_var_bat_paging"
    "--skip=list_languages"
    "--skip=pager_arg_override_env_noconfig"
    "--skip=pager_arg_override_env_withconfig"
    "--skip=pager_basic"
    "--skip=pager_basic_arg"
    "--skip=pager_env_bat_pager_override_config"
    "--skip=pager_env_pager_nooverride_config"
    "--skip=pager_more"
    "--skip=pager_most"
    "--skip=pager_overwrite"
    "--skip=plain_without_diff_still_works"
    "--skip=s_flag_respected_with_paging_always"
    "--skip=simple_plain_does_not_override_paging"
    "--skip=wrap_never_flag_respected_with_paging_always"
    # Fails if the filesystem performs UTF-8 validation (such as ZFS with utf8only=on)
    "--skip=file_with_invalid_utf8_filename"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    testFile=$(mktemp /tmp/bat-test.XXXX)
    echo -ne 'Foobar\n\n\n42' > $testFile
    $out/bin/bat -p $testFile | grep "Foobar"
    $out/bin/bat -p $testFile -r 4:4 | grep 42
    rm $testFile

    runHook postInstallCheck
  '';

  meta = {
    description = "Cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    mainProgram = "bat";
    maintainers = with lib.maintainers; [
      dywedir
      zowoq
      SuperSandro2000
      sigmasquadron
    ];
  };
})
