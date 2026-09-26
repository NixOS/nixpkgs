{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mcap-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "foxglove";
    repo = "mcap";
    tag = "releases/mcap-cli/v${finalAttrs.version}";
    hash = "sha256-QVJA/RZPamkBYkFNJn9uB1/cok6lEF/U7ssmdmzp4og=";
  };

  cargoHash = "sha256-7WsGJd+KNNCke9pmvwN6zi0bDXBGfQcEotIxyYdUWAo=";

  # The repository root is a Cargo workspace of the `mcap` library and this CLI;
  # build and test only the CLI member.
  buildAndTestSubdir = "rust/cli";

  # The tests these skip read fixtures under testdata/ and tests/conformance/data/, which
  # are Git LFS objects: a source tarball carries the pointer files, not the payload.
  # https://github.com/foxglove/mcap/issues/895
  checkFlags = [
    "--skip=commands::cat::tests::cat_falls_back_for_summary_channel_with_in_chunk_schema"
    "--skip=commands::cat::tests::cat_indexed_applies_topic_filter_to_chunk_local_channels"
    "--skip=commands::cat::tests::cat_indexed_reads_chunk_index_without_message_indexes_and_in_chunk_channels"
    "--skip=commands::cat::tests::cat_indexed_reads_message_index_with_in_chunk_channels"
    "--skip=commands::cat::tests::chunk_local_channels_keep_remote_topic_plan_conservative"
    "--skip=commands::convert::ros1_bag::tests::convert_real_bz2_ros1_bag_fixture"
    "--skip=commands::convert::ros1_bag::tests::convert_real_uncompressed_ros1_bag_fixture"
    "--skip=commands::convert::ros2_db3::tests::converts_iron_talker_db3_with_embedded_schemas"
    "--skip=commands::convert::ros2_db3::tests::rejects_humble_talker_db3_without_embedded_schemas"
    "--skip=commands::convert::ros2_db3::tests::rejects_humble_talker_db3_without_truncating_existing_output"
    "--skip=commands::convert::tests::convert_command_handles_noetic_generated_ros1_bags"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # Completions come out of the built binary, so a cross build needs an emulator to
  # run it. Guarding on emulatorAvailable rather than canExecute keeps all three
  # shells installed when one exists, and skips them only when none does.
  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd mcap \
        --bash <(${emulator} $out/bin/mcap completion bash) \
        --fish <(${emulator} $out/bin/mcap completion fish) \
        --zsh <(${emulator} $out/bin/mcap completion zsh)
    ''
  );

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "releases/mcap-cli/v(.*)"
    ];
  };

  meta = {
    description = "MCAP CLI tool to inspect and fix MCAP files";
    homepage = "https://github.com/foxglove/mcap";
    changelog = "https://github.com/foxglove/mcap/releases/tag/releases/mcap-cli/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      therishidesai
      stfl
    ];
    mainProgram = "mcap";
  };
})
