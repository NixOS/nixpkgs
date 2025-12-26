{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pkdns";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "pubky";
    repo = "pkdns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2bLOl4xDSoNwmGzaaGVmjlzifJjftRID5iSof4D/SfU=";
  };

  cargoHash = "sha256-sbJb+rdrabmbHsv9ijc/APvTtRrZHSrgAlSPzYrgLTc=";

  # skip tests, which rely on an external network
  checkFlags = [
    "--skip=dns_over_https"
    "--skip=external_ip"
    "--skip=resolution::dns_socket"
    "--skip=resolution::pkd::bootstrap_nodes"
    "--skip=resolution::pkd::pkarr_resolver::tests::pkarr_invalid_packet1"
    "--skip=resolution::pkd::pkarr_resolver::tests::query"
    "--skip=resolution::pkd::query_matcher"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "DNS server resolving pkarr self-sovereign domains";
    homepage = "https://github.com/pubky/pkdns";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "pkdns";
    platforms = lib.platforms.unix;
  };
})
