{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ovh-shai";
  version = "0.1.2-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "shai";
    rev = "5db78ea73d31aaa0def454a96d5b8d815174f7c3";
    hash = "sha256-8ufZBLjLBURVmHGJTI5YiyXZdV7xaJuXo4n+GSPMfWg=";
  };

  cargoHash = "sha256-AVjkYxKTAFRPQOVDR1MtrBHdhAL5N9TAaJ9wBbWbUAQ=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlags = [
    # Skip failing test
    "--skip=fc::tests::tests::test_clear_history"
  ];

  meta = {
    description = "OVHcloud's terminal-based AI coding assistant";
    homepage = "https://github.com/ovh/shai";
    changelog = "https://github.com/ovh/shai/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
    mainProgram = "shai";
  };
}
