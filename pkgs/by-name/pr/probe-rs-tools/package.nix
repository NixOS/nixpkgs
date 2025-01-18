{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, gitMinimal
, pkg-config
, libusb1
, openssl
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs-tools";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "probe-rs";
    repo = "probe-rs";
    rev = "v${version}";
    hash = "sha256-H1RT+H7aQjZmesW+/0mjPH2M01J1eBZ47Rern5lCqWk=";
  };

  cargoHash = "sha256-aTBtWPcOYT5koIu/uw5S2oKTnsvXcqB39SFbe8U1NJY=";

  buildAndTestSubdir = pname;

  nativeBuildInputs = [
    # required by libz-sys, no option for dynamic linking
    # https://github.com/rust-lang/libz-sys/issues/158
    cmake
    # build.rs fails without git
    # https://github.com/probe-rs/probe-rs/pull/2492
    gitMinimal
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 openssl ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  checkFlags = [
    # require a physical probe
    "--skip=cmd::dap_server::server::debugger::test::attach_request"
    "--skip=cmd::dap_server::server::debugger::test::attach_with_flashing"
    "--skip=cmd::dap_server::server::debugger::test::launch_and_threads"
    "--skip=cmd::dap_server::server::debugger::test::launch_with_config_error"
    "--skip=cmd::dap_server::server::debugger::test::test_initalize_request"
    "--skip=cmd::dap_server::server::debugger::test::test_launch_and_terminate"
    "--skip=cmd::dap_server::server::debugger::test::test_launch_no_probes"
    "--skip=cmd::dap_server::server::debugger::test::wrong_request_after_init"
    # compiles an image for an embedded target which we do not have a toolchain for
    "--skip=util::cargo::test::get_binary_artifact_with_cargo_config"
    "--skip=util::cargo::test::get_binary_artifact_with_cargo_config_toml"
    # requires other crates in the workspace
    "--skip=util::cargo::test::get_binary_artifact"
    "--skip=util::cargo::test::library_with_example_specified"
    "--skip=util::cargo::test::multiple_binaries_in_crate_select_binary"
    "--skip=util::cargo::test::workspace_binary_package"
    "--skip=util::cargo::test::workspace_root"
  ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ xgroleau newam ];
  };
}
