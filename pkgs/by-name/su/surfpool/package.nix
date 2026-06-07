{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  versionCheckHook,
  openssl,
}:

let
  studioUiVersion = "v0.1.0";
  studioUi = fetchurl {
    url = "https://github.com/solana-foundation/surfpool-web-ui/releases/download/${studioUiVersion}/studio-dist.zip";
    hash = "sha256-DeWm2FzZbdaHXaEFA8W/YIIcJx4Z+uFkrxuajTM9n1M=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "surfpool-cli";
  version = "1.3.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "solana-foundation";
    repo = "surfpool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZxF2wysE48C14gm62hsWHh/i6BWTmTNUB/tBReqCue8=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-WYsTPgRhC44KF/phjSy3iCwQQCTaqrB40/jWA6IdW30=";

  env = {
    RUSTFLAGS = "-Aunused";
    OPENSSL_NO_VENDOR = 1;
    STUDIO_UI_DIST = "${studioUi}";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Surfpool is where developers start their Solana journey";
    homepage = "https://www.surfpool.run/";
    longDescription = ''
      Surfpool is a drop-in replacement for solana-test-validator that lets
      developers spin up local Solana networks mirroring mainnet state without
      downloading the entire chain. It includes a built-in web UI (Surfpool Studio)
      served directly from the binary, Infrastructure as Code for declarative
      program deployment, transaction inspection, time travel, cheatcodes, and
      an MCP server for agentic workflows
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _0xgsvs ];
    mainProgram = "surfpool";
  };
})
