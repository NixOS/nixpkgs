{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  versionCheckHook,
  buildRustyV8,
}:
let
  librusty_v8 = buildRustyV8 rec {
    version = "145.0.0";
    src = fetchFromGitHub {
      owner = "denoland";
      repo = "rusty_v8";
      tag = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-uFB5Ao92c4tTTpEli5se8I9fvBrNHrDV3sbxJDokp/M=";
    };
    cargoHash = "sha256-YlEn1fUmIELz+80EMM4fc2BWG0y/700SIiNs8GIOtoY=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "2.5.0-hotfix1";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CXc/AKzK4aTVhKgzIzkA5cdInYqOu7sMdCUyeSwixbc=";
  };

  cargoHash = "sha256-iO1TGctPVmQxn1h+Md6p3pbEkfXNX91n5NZhIDK5BLI=";

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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  passthru = {
    updateScript = ./update.sh;
    inherit librusty_v8;
  };

  meta = {
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
