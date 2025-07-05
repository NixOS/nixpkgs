{
  lib,
  bash,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  nixosTests,
  pam,
  pandoc,
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
  useFetchCargoVendor = true;
  cargoHash = "sha256-o3//zJxB6CNHQl1DtfmFnSBP9npC4I9/hRuzpWrKoNs=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  buildInputs = [ pam ];

  # Don't attempt to generate the docs in a (pan)Docker container
  postPatch = ''
    substituteInPlace util/generate-docs.sh \
      --replace-fail "/usr/bin/env bash" ${lib.getExe bash} \
      --replace-fail util/pandoc.sh pandoc

    substituteInPlace build.rs \
      --replace-fail "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  postInstall = ''
    ./util/generate-docs.sh
    installManPage target/docs/man/*
  '';

  checkFlags = map (t: "--skip=${t}") [
    # Those tests make path assumptions
    "common::command::test::test_build_command_and_args"
    "common::context::tests::test_build_context"
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

    # This expects some PATH_TZINFO environment var
    "env::environment::tests::test_tzinfo"

    # Unsure why those are failing
    "env::tests::test_environment_variable_filtering"
    "su::context::tests::invalid_shell"
  ];

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
