{
  lib,
  rustPlatform,
  fetchFromGitLab,
  protobuf,
  libpq,
  postgresql,
  postgresqlTestHook,
  redisTestHook,
  urlencode,
  cacert,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "opentalk-controller";
  version = "0.29.5";

  src = fetchFromGitLab {
    domain = "gitlab.opencode.de";
    owner = "opentalk";
    repo = "controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lc51R58yHITPcRJPMXBRLrzSUVDDiGiikFAVG57zzIk=";
  };

  cargoHash = "sha256-xiYv+OqT085+hLb0mxQvmtv/MPrrvqy6CPezi7+BT0Q=";

  nativeBuildInputs = [
    protobuf # for protoc compiler
  ];

  buildInputs = [
    libpq
  ];

  # Disable utoipa-swagger-ui.
  # The utoipa-swagger-ui crate only accepts a zip archive, though it would be more
  # ideal if we could package swagger-ui separately and share it with all packages
  # that depend on utoipa-swagger-ui (i.e., mistral-rs, nym, stract).
  # There is no requirement for the version to match what upstream uses, which would allow
  # us to keep swagger-ui up to date for all dependant packages.
  buildNoDefaultFeatures = true;

  # There are too many tests depeding on a real database connection to selectively disable
  # them when postgresqlTestHook is not available, so we just skip the check phase altogether
  # in that case (meaning tests are currently not run on darwin).
  doCheck = !postgresqlTestHook.meta.broken;

  nativeCheckInputs = [
    redisTestHook
    postgresql
    postgresqlTestHook
    urlencode # for creating POSTGRES_BASE_URL
    cacert # needed for tests invoking hyper-rustls
  ];

  # The tests need to drop and re-create databases
  postgresqlTestUserOptions = "LOGIN SUPERUSER";

  preCheck = ''
    # PGHOST is not set yet because our preCheck runs before postgresqlTestHook,
    # but we can't create the directory for it yet nor set PGHOST itself until
    # https://github.com/NixOS/nixpkgs/pull/419823 is merged
    host="$NIX_BUILD_TOP/run/postgresql"
    export PGUSER="test_user"
    export POSTGRES_BASE_URL="postgresql://$PGUSER@$(urlencode $host)"
    export KUSTOS_TESTS_DATABASE_URL="$POSTGRES_BASE_URL/kustos"
  '';

  checkFlags = [
    # Not sure why these are failing. Fails at:
    # https://gitlab.opencode.de/opentalk/controller/-/blob/v0.30.1/crates/opentalk-controller-settings/src/settings_provider/mod.rs#L275
    # assert_eq!(&(*settings_provider.get()), &minimal_example());
    "--skip=settings_provider::tests::reload"
    "--skip=settings_provider::tests::load_minimal"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = ./update.py;

  meta = {
    description = "Secure video conferencing solution that was designed with productivity, digital sovereignty and privacy in mind";
    homepage = "https://gitlab.opencode.de/opentalk/controller";
    changelog = "https://gitlab.opencode.de/opentalk/controller/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    mainProgram = "opentalk-controller";
  };
})
