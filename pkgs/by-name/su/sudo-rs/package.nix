{
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  nixosTests,
  versionCheckHook,
  pam,
  rustPlatform,
  tzdata,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sudo-rs";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "trifectatechfoundation";
    repo = "sudo-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-02ODKMumYUKcmSfPAiCwpRph5+Zy+g5uqqbJ9ThRxRg=";
  };

  cargoHash = "sha256-o3//zJxB6CNHQl1DtfmFnSBP9npC4I9/hRuzpWrKoNs=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ pam ];

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postInstall = ''
    for man_fn in docs/man/*.man; do
      man_fn_fixed="$(echo "$man_fn" | sed -e 's,\.man$,,')"
      ln -vs $(basename "$man_fn") "$man_fn_fixed"
      installManPage "$man_fn_fixed"
    done
  '';

  checkFlags = map (t: "--skip=${t}") [
    # Those tests make path assumptions
    "common::command::test::test_build_command_and_args"
    "common::context::tests::test_build_run_context"
    "common::resolve::test::canonicalization"
    "common::resolve::tests::test_resolve_path"
    "system::tests::kill_test"

    # Assumes $SHELL is an actual shell
    "su::context::tests::su_to_root"

    # Attempts to access /etc files from the build sandbox
    "system::audit::test::secure_open_is_predictable"

    # Assume there is a `daemon` user and group
    "system::interface::test::test_unix_group"
    "system::interface::test::test_unix_user"
    "system::tests::test_get_user_and_group_by_id"

    # Unsure why those are failing
    "env::tests::test_environment_variable_filtering"
    "su::context::tests::invalid_shell"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  # sudo binary fails because it checks if it is suid 0
  versionCheckProgram = "${placeholder "out"}/bin/su";
  versionCheckProgramArg = "--version";

  postInstallCheck = ''
    [ -e ${placeholder "out"}/share/man/man8/sudo.8.gz ] || \
      ( echo "Error: Some manpages might be missing!"; exit 1 )
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9])$"
      ];
    };
    tests = nixosTests.sudo-rs;
  };

  meta = {
    description = "Memory safe implementation of sudo and su";
    homepage = "https://github.com/trifectatechfoundation/sudo-rs";
    changelog = "${finalAttrs.meta.homepage}/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      nicoo
      rvdp
    ];
    mainProgram = "sudo";
    platforms = lib.platforms.linux;
  };
})
