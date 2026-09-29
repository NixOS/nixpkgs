{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "superseedr";
  version = "0.9.29";

  src = fetchFromGitHub {
    owner = "Jagalite";
    repo = "superseedr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EszIDtwteskQrD3GBmGsGBnmO+UGE7DSpER7CSSdR2U=";
  };
  cargoHash = "sha256-HfO+cbrM+WpZDTHB/W92U8EO0yswK4q02SuB3rTZJL4=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # Skip tests accessing network stack
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=networking::protocol::tests"
    "--skip=torrent_manager::manager::resource_tests::test_cpu_hashing_is_non_blocking"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "BitTorrent Client in your Terminal";
    longDescription = ''
      Superseedr is a modern Rust BitTorrent client featuring a
      high-performance terminal UI, real-time swarm observability,
      secure VPN-aware Docker setups, and zero manual network
      configuration. It is fast, privacy-oriented, and built for both
      desktop users and homelab/server workflows.
    '';
    homepage = "https://github.com/Jagalite/superseedr";
    license = lib.licenses.gpl3Plus;
    mainProgram = "superseedr";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
