{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JuZ9odvMTIOIG4G0M4IBS9I9mWV+dk6qltIgn2a/W9I=";
  };

  cargoHash = "sha256-yAXcTNBITuBm7NPCTiS/RDaxMYgH6mq+ud3VsOELEqE=";

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  cargoBuildFlags = [ "-p spacetimedb-standalone -p spacetimedb-cli" ];

  preCheck = ''
    # server tests require home dir
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # require wasm32-unknown-unknown target
    "--skip=codegen"
    "--skip=publish"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # flakes on darwin in nix build sandbox, timing out waiting for listen addr
    "--skip=cli_can_ping_spacetimedb_on_disk"
    "--skip=cli_can_publish_spacetimedb_on_disk"
    "--skip=cli_can_publish_no_conflict_does_not_delete_data"
    "--skip=cli_can_publish_no_conflict_with_delete_data_flag"
    "--skip=cli_can_publish_no_conflict_without_delete_data_flag"
    "--skip=cli_can_publish_with_automigration_change"
    "--skip=cli_cannot_publish_automigration_change_without_yes_break_clients"
    "--skip=cli_can_publish_automigration_change_with_on_conflict_and_yes_break_clients"
    "--skip=cli_cannot_publish_automigration_change_with_on_conflict_without_yes_break_clients"
    "--skip=cli_can_publish_automigration_change_with_delete_data_always_without_yes_break_clients"
    "--skip=cli_can_publish_automigration_change_with_delete_data_always_and_yes_break_clients"
    "--skip=cli_cannot_publish_breaking_change_without_flag"
    "--skip=cli_can_publish_breaking_change_with_delete_data_flag"
    "--skip=cli_can_publish_breaking_change_with_on_conflict_flag"
  ];

  doInstallCheck = true;

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
    # used by crates/cli/build.rs to set GIT_HASH at compile time
    SPACETIMEDB_NIX_BUILD_GIT_COMMIT = finalAttrs.src.rev;
    # required to make jemalloc_tikv_sys build
    CFLAGS = "-O";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";

  postInstall = ''
    mv $out/bin/spacetimedb-cli $out/bin/spacetime
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
