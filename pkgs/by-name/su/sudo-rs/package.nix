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
<<<<<<< HEAD
  version = "0.2.11";
=======
  version = "0.2.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "trifectatechfoundation";
    repo = "sudo-rs";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-F1JwVP2GDzKCfiJXh8PXTBghNwWeD8a+TMiEaPx6wGg=";
  };

  cargoHash = "sha256-6NhyPdOAk2va8Vibsfpfq3xGLIzDBRmqxj4bZhQT9bY=";
=======
    hash = "sha256-DGoEHeVs7EbzpfbmJQEIsL/eWXBvUCbaSPAGD65Op7k=";
  };

  cargoHash = "sha256-fn97cKdaIsbozI794CAeWQooC7evTErRJOg6cEjzvjY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ pam ];

  postPatch = ''
<<<<<<< HEAD
    substituteInPlace src/system/audit.rs \
      --replace-fail '/usr/share/zoneinfo' '/etc/zoneinfo' \
      --replace-fail '/usr/share/lib/zoneinfo' '${tzdata}/share/zoneinfo'
=======
    substituteInPlace build.rs \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  postInstall = ''
    for man_fn in docs/man/*.man; do
      man_fn_fixed="$(echo "$man_fn" | sed -e 's,\.man$,,')"
      ln -vs $(basename "$man_fn") "$man_fn_fixed"
      installManPage "$man_fn_fixed"
    done

    ln -s $out/share/man/man8/{sudo,sudoedit}.8.gz
    ln -s $out/bin/{sudo,sudoedit}
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

<<<<<<< HEAD
    # Store paths are not owned by root in the build sandbox, so the zoneinfo path
    # doesn't pass the validations done by sudo-rs.
    # This is not an issue at runtime, since there the zoneinfo path is owned by root.
    "sudo::env::environment::tests::test_tzinfo"

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # Unsure why those are failing
    "env::tests::test_environment_variable_filtering"
    "su::context::tests::invalid_shell"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  # sudo binary fails because it checks if it is suid 0
  versionCheckProgram = "${placeholder "out"}/bin/su";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstallCheck = ''
    [ -e ${placeholder "out"}/share/man/man8/sudo.8.gz ] || \
      ( echo "Error: Some manpages might be missing!"; exit 1 )
  '';

  passthru = {
<<<<<<< HEAD
    updateScript = nix-update-script { };
=======
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9])$"
      ];
    };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      adamcstephens
      nicoo
      rvdp
    ];
    mainProgram = "sudo";
    platforms = lib.platforms.linux;
  };
})
