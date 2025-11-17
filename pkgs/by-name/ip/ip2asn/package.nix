{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ip2asn";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "x123";
    repo = "ip2asn";
    tag = finalAttrs.version;
    hash = "sha256-2wuxBwllrkPdmmBCt7DPQ38E2k3igAjbICun51bhopY=";
  };

  cargoHash = "sha256-fYg0aIU8usueMg6cMWUcwMIFCinHdm6H7k9ywZGYfg8=";

  passthru.updateScript = nix-update-script { };

  cargoBuildFlags = [
    "-p"
    "ip2asn-cli"
  ];

  # disable network based tests that download data
  cargoTestFlags = [
    "-p"
    "ip2asn-cli"
    "--"
    "--skip"
    "auto_update_tests::test_auto_update_triggers_download"
    "--skip"
    "auto_update_tests::test_auto_update_skips_check_for_recent_cache"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "CLI tool for mapping IP addresses to Autonomous System information";
    homepage = "https://github.com/x123/ip2asn/tree/master/ip2asn-cli";
    changelog = "https://github.com/x123/ip2asn/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "ip2asn";
  };
})
