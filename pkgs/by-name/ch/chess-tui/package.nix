{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "chess-tui";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "thomas-mauran";
    repo = "chess-tui";
    tag = finalAttrs.version;
    hash = "sha256-wTGEu3RbxZysftXNmCSdhdviMMuFiFMxoA1w5Lfp4HA=";
  };

  cargoHash = "sha256-LNaAJ10e94uy1GacQTzXH4TSxeXiN4gmvoyMCjKYnEU=";

  checkFlags = [
    # assertion failed: result.is_ok()
    "--skip=tests::test_config_create"
  ];

  buildInputs = [
    openssl
  ]
  # alsa-lib is required for the alsa-sys. alsa-lib does not compile on darwin
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
  # bindgenHook is required for coreaudio-sys on darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ rustPlatform.bindgenHook ];

  nativeBuildInputs = [ pkg-config ];

  env.PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Chess TUI implementation in rust";
    homepage = "https://github.com/thomas-mauran/chess-tui";
    maintainers = with lib.maintainers; [ ByteSudoer ];
    license = lib.licenses.mit;
    mainProgram = "chess-tui";
  };
})
