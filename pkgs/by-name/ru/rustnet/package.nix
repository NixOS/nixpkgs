{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  elfutils,
  zlib,
  libbpf,
  libpcap,
  clangStdenv,
}:
let
  pname = "rustnet";
  version = "1.7.0";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${version}";
    hash = "sha256-sSNXcC3o0JxQ6VHDM6spSV+VAnH137asCSb/sYLmudE=";
  };

  cargoHash = "sha256-99kickqamV/WM9Bd7WjKiMvMIGl6rOwgHXF2D0UhZLI=";

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
  ];

  buildInputs = [
    elfutils
    libbpf
    libpcap
    zlib
  ];

  # Required for libbpf-sys to build correctly
  hardeningDisable = [
    "zerocallusedregs"
  ];

  # Set environment variables for libbpf-sys
  env = {
    LIBBPF_SYS_LIBRARY_PATH = "${libbpf}/lib";
    LIBBPF_SYS_INCLUDE_PATH = "${libbpf}/include";
  };

  checkFlags = [
    "--skip=network::platform::linux::interface_stats::tests::test_get_all_stats"
    "--skip=network::platform::linux::interface_stats::tests::test_list_interfaces"
    # These assume filesystem ownership/permission semantics that don't hold in the Nix build sandbox
    "--skip=app::output::staged_tests::descriptor_collision_preserves_existing_contents"
    "--skip=app::output::staged_tests::distinct_outputs_append_logs_and_truncate_capture_files"
    "--skip=app::output::staged_tests::distinct_stdout_remains_writable_after_output_preparation"
    "--skip=app::output::staged_tests::later_open_failure_preserves_every_existing_output"
    "--skip=app::output::staged_tests::new_case_aliases_do_not_truncate_an_earlier_output"
    "--skip=app::output::staged_tests::new_unicode_aliases_do_not_truncate_an_earlier_output"
    "--skip=app::output::staged_tests::opened_stdout_collisions_preserve_every_artifact"
    "--skip=app::output::tests::appends_rather_than_truncates"
    "--skip=app::output::tests::creates_file_with_0600_permissions"
    "--skip=app::output::tests::refuses_symlinked_path"
    "--skip=app::output::tests::rejects_hard_linked_outputs"
    "--skip=app::output::tests::retained_descriptor_survives_inaccessible_parent"
    "--skip=app::output::tests::tightens_permissions_on_an_existing_file"
    "--skip=app::unix_output::tests::diagnostic_file_is_exclusive_and_preserves_planted_content"
    "--skip=app::unix_output::tests::retained_parent_descriptor_survives_directory_swap"
    "--skip=app::unix_output::tests::search_only_ancestor_allows_output_and_diagnostic_creation"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance, cross-platform network monitoring terminal UI tool built with Rust";
    homepage = "https://github.com/domcyrus/rustnet";
    changelog = "https://github.com/domcyrus/rustnet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvaerum ];
    mainProgram = "rustnet";
    platforms = lib.platforms.linux;
  };
}
