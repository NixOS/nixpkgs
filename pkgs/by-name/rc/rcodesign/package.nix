{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  uutils-coreutils,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rcodesign";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = "apple-platform-rs";
    tag = "apple-codesign/${version}";
    hash = "sha256-NyO0HkldXh94Y16E+SX1VE/OOx0zgO6VYoRLJrEQUm0=";
  };

  cargoHash = "sha256-KJsTOviCFZ/1eNJLM4+QmK8h6laxN1POl7YMJyu9/g8=";

  cargoBuildFlags = [
    # Only build the binary we want
    "--bin=rcodesign"
  ];

  checkFlags = [
    # Does network IO
    "--skip=cli_tests"
    "--skip=ticket_lookup::test::lookup_ticket"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These tests require Xcode to be installed
    "--skip=parsed_sdk::test::find_all_sdks"
    "--skip=simple_sdk::test::find_all_sdks"
    "--skip=test::find_all_platform_directories"

    # Error: Io(Os { code: 1, kind: PermissionDenied, message: "Operation not permitted" })
    "--skip=test::find_system_xcode_applications"
    "--skip=test::find_system_xcode_developer_directories"
  ];

  # Set up uutils-coreutils for cli_tests. Without this, it will be installed with `cargo install`, which will fail
  # due to the lack of network access in the build environment.
  preCheck = ''
    coreutils_dir=''${CARGO_TARGET_DIR:-"$(pwd)/target"}/${stdenv.hostPlatform.rust.cargoShortTarget}/coreutils/bin
    install -m 755 -d "$coreutils_dir"
    ln -s '${lib.getExe' uutils-coreutils "uutils-coreutils"}' "$coreutils_dir/coreutils"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Cross-platform CLI interface to interact with Apple code signing";
    mainProgram = "rcodesign";
    longDescription = ''
      rcodesign provides various commands to interact with Apple signing,
      including signing and notarizing binaries, generating signing
      certificates, and verifying existing signed binaries.

      For more information, refer to the [documentation](https://gregoryszorc.com/docs/apple-codesign/stable/apple_codesign_rcodesign.html).
    '';
    homepage = "https://github.com/indygreg/apple-platform-rs";
    changelog = "https://github.com/indygreg/apple-platform-rs/releases/tag/apple-codesign%2F${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ euank ];
  };
}
