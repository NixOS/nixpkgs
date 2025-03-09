{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk_11,
  uutils-coreutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "rcodesign";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = "apple-platform-rs";
    rev = "apple-codesign/${version}";
    hash = "sha256-xyjq5mdc29OwzlUAQZWSg1k68occ81i7KBGUiiq0ke0=";
  };

  patches = [
    # Disable cli_tests test that requires network access.
    ./disable-sign-for-notarization-test.patch
  ];

  cargoHash = "sha256-xMhyKovXoBPZp6epWQ+CYODpyvHgpv6eZfdWPTuDnK8=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  cargoBuildFlags = [
    # Only build the binary we want
    "--bin"
    "rcodesign"
  ];

  checkFlags = [
    # Does network IO
    "--skip=ticket_lookup::test::lookup_ticket"
    # These tests require Xcode to be installed
    "--skip=find_all_platform_directories"
    "--skip=find_all_sdks"
  ];

  # Set up uutils-coreutils for cli_tests. Without this, it will be installed with `cargo install`, which will fail
  # due to the lack of network access in the build environment.
  preCheck = ''
    coreutils_dir=''${CARGO_TARGET_DIR:-"$(pwd)/target"}/${stdenv.hostPlatform.rust.cargoShortTarget}/coreutils/bin
    install -m 755 -d "$coreutils_dir"
    ln -s '${lib.getExe' uutils-coreutils "uutils-coreutils"}' "$coreutils_dir/coreutils"
  '';

  meta = with lib; {
    description = "Cross-platform CLI interface to interact with Apple code signing";
    mainProgram = "rcodesign";
    longDescription = ''
      rcodesign provides various commands to interact with Apple signing,
      including signing and notarizing binaries, generating signing
      certificates, and verifying existing signed binaries.

      For more information, refer to the [documentation](https://gregoryszorc.com/docs/apple-codesign/stable/apple_codesign_rcodesign.html).
    '';
    homepage = "https://github.com/indygreg/apple-platform-rs";
    license = licenses.mpl20;
    maintainers = with maintainers; [ euank ];
  };
}
